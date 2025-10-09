import SwiftUI
import Combine

struct FocusView: View {
    let sessionMinutes: Int
    let podId: String? // Optional: if user is in a pod

    @State private var remainingSeconds: Int
    @State private var isRunning: Bool = false
    @State private var sessionStartTime: Date?
    @State private var showingResults: Bool = false
    @State private var lastSessionResult: SessionResult?
    
    @StateObject private var motionManager = MotionManager()
    @EnvironmentObject private var firebaseService: FirebaseService
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(sessionMinutes: Int, podId: String? = nil) {
        self.sessionMinutes = sessionMinutes
        self.podId = podId
        _remainingSeconds = State(initialValue: max(0, sessionMinutes) * 60)
    }

    var body: some View {
        VStack(spacing: 24) {
            // Timer display
            Text(formattedTime)
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .monospacedDigit()
                .padding(.top, 40)
            
            // Motion stats
            if isRunning {
                VStack(spacing: 12) {
                    HStack(spacing: 20) {
                        StatusIndicator(
                            label: "Face Down",
                            isActive: motionManager.isFaceDown,
                            percentage: motionManager.faceDownPercentage
                        )
                        
                        StatusIndicator(
                            label: "Steady",
                            isActive: motionManager.isSteady,
                            percentage: motionManager.steadyPercentage
                        )
                    }
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(12)
            }

            // Control buttons
            HStack(spacing: 16) {
                Button(action: start) {
                    Label("Start", systemImage: "play.fill")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(isRunning || remainingSeconds == 0)

                Button(action: stop) {
                    Label("Stop", systemImage: "stop.fill")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(!isRunning)
            }

            Spacer()
        }
        .padding()
        .onReceive(timer) { _ in
            guard isRunning else { return }
            tick()
        }
        .onChange(of: isRunning) { _, newValue in
            setIdleTimerDisabled(newValue)
            
            if newValue {
                motionManager.startMonitoring()
            } else {
                motionManager.stopMonitoring()
            }
        }
        .onDisappear {
            setIdleTimerDisabled(false)
            motionManager.stopMonitoring()
        }
        .navigationTitle("Focus")
        .sheet(isPresented: $showingResults) {
            if let result = lastSessionResult {
                SessionResultView(result: result)
            }
        }
    }

    private var formattedTime: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func start() {
        guard remainingSeconds > 0 else { return }
        sessionStartTime = Date()
        motionManager.resetStats()
        isRunning = true
    }

    private func stop() {
        isRunning = false
        endSession()
    }

    private func tick() {
        if remainingSeconds > 0 {
            remainingSeconds -= 1
            if remainingSeconds == 0 {
                isRunning = false
                setIdleTimerDisabled(false)
                endSession()
            }
        }
    }
    
    private func endSession() {
        guard let startTime = sessionStartTime,
              let userId = firebaseService.currentUserId else {
            return
        }
        
        let endTime = Date()
        let duration = Int(endTime.timeIntervalSince(startTime))
        
        // Session passes if face down >= 80% AND steady >= 70%
        let passed = motionManager.faceDownPercentage >= 80.0 && 
                    motionManager.steadyPercentage >= 70.0
        
        let result = SessionResult(
            userId: userId,
            podId: podId,
            startTime: startTime,
            endTime: endTime,
            durationSeconds: duration,
            faceDownPercentage: motionManager.faceDownPercentage,
            steadyPercentage: motionManager.steadyPercentage,
            passed: passed
        )
        
        lastSessionResult = result
        
        // Save to Firestore
        Task {
            do {
                try await firebaseService.saveSessionResult(result)
                showingResults = true
            } catch {
                print("❌ Failed to save session: \(error.localizedDescription)")
            }
        }
    }

    private func setIdleTimerDisabled(_ disabled: Bool) {
        #if os(iOS)
        UIApplication.shared.isIdleTimerDisabled = disabled
        #endif
    }
}

// MARK: - Supporting Views

struct StatusIndicator: View {
    let label: String
    let isActive: Bool
    let percentage: Double
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Circle()
                    .fill(isActive ? Color.green : Color.gray)
                    .frame(width: 10, height: 10)
                Text(label)
                    .font(.caption)
            }
            Text(String(format: "%.0f%%", percentage))
                .font(.title2)
                .fontWeight(.semibold)
        }
    }
}

struct SessionResultView: View {
    let result: SessionResult
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                // Pass/Fail header
                VStack(spacing: 8) {
                    Image(systemName: result.passed ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(result.passed ? .green : .red)
                    
                    Text(result.passed ? "Session Passed!" : "Session Failed")
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding(.top, 40)
                
                // Stats
                VStack(spacing: 20) {
                    StatRow(label: "Duration", value: String(format: "%.1f min", result.durationMinutes))
                    StatRow(label: "Face Down", value: String(format: "%.1f%%", result.faceDownPercentage))
                    StatRow(label: "Steady", value: String(format: "%.1f%%", result.steadyPercentage))
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(16)
                
                Text("Goal: 80% face down, 70% steady")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button("Done") {
                    dismiss()
                }
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding()
            .navigationTitle("Results")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct StatRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
            Spacer()
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    NavigationView {
        FocusView(sessionMinutes: 25)
            .environmentObject(FirebaseService())
    }
}
