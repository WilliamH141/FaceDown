//
//  MotionManager.swift
//  FaceDown
//
//  Handles CoreMotion detection for face-down and steady states
//

import Foundation
import CoreMotion
import Combine

class MotionManager: ObservableObject {
    @Published var isFaceDown: Bool = false
    @Published var isSteady: Bool = false
    @Published var faceDownPercentage: Double = 0.0
    @Published var steadyPercentage: Double = 0.0
    
    private let motionManager = CMMotionManager()
    private var totalSamples: Int = 0
    private var faceDownSamples: Int = 0
    private var steadySamples: Int = 0
    
    // Thresholds
    private let faceDownThreshold: Double = -0.75 // z-axis gravity when face down
    private let steadyThreshold: Double = 0.15 // acceleration magnitude for steady state
    
    func startMonitoring() {
        guard motionManager.isDeviceMotionAvailable else {
            print("Device motion not available")
            return
        }
        
        resetStats()
        
        motionManager.deviceMotionUpdateInterval = 0.1 // 10 Hz
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
            guard let self = self, let motion = motion else { return }
            self.processMotion(motion)
        }
    }
    
    func stopMonitoring() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    private func processMotion(_ motion: CMDeviceMotion) {
        totalSamples += 1
        
        // Check if face down (z-axis gravity pointing down)
        let zGravity = motion.gravity.z
        let currentlyFaceDown = zGravity < faceDownThreshold
        
        // Check if steady (low user acceleration)
        let userAccel = motion.userAcceleration
        let accelMagnitude = sqrt(
            pow(userAccel.x, 2) + 
            pow(userAccel.y, 2) + 
            pow(userAccel.z, 2)
        )
        let currentlySteady = accelMagnitude < steadyThreshold
        
        // Update current states
        isFaceDown = currentlyFaceDown
        isSteady = currentlySteady
        
        // Update cumulative stats
        if currentlyFaceDown {
            faceDownSamples += 1
        }
        if currentlySteady {
            steadySamples += 1
        }
        
        // Calculate percentages
        if totalSamples > 0 {
            faceDownPercentage = Double(faceDownSamples) / Double(totalSamples) * 100.0
            steadyPercentage = Double(steadySamples) / Double(totalSamples) * 100.0
        }
    }
    
    func resetStats() {
        totalSamples = 0
        faceDownSamples = 0
        steadySamples = 0
        faceDownPercentage = 0.0
        steadyPercentage = 0.0
        isFaceDown = false
        isSteady = false
    }
}


