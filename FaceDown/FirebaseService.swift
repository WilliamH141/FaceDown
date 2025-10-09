import Foundation
import Combine
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class FirebaseService: ObservableObject {
    private let db = Firestore.firestore()
    @Published var currentUserId: String?

    init() {}

    static func configure() { FirebaseApp.configure() }

    func signInAnonymously() async throws {
        let res = try await Auth.auth().signInAnonymously()
        await MainActor.run {
            currentUserId = res.user.uid
        }
        print("✅ Signed in anonymously: \(res.user.uid)")
    }

    func saveSessionResult(_ result: SessionResult) async throws {
        let ref = db.collection("sessions").document()
        try await ref.setData(result.dictionary)
        print("✅ Session saved: \(ref.documentID)")
    }

    func fetchUserSessions(userId: String, limit: Int = 10) async throws -> [SessionResult] {
        let snap = try await db.collection("sessions")
            .whereField("userId", isEqualTo: userId)
            .order(by: "startTime", descending: true)
            .limit(to: limit)
            .getDocuments()

        return snap.documents.compactMap { SessionResult(from: $0.data()) }
    }

    func fetchPodSessions(podId: String, limit: Int = 50) async throws -> [SessionResult] {
        let snap = try await db.collection("sessions")
            .whereField("podId", isEqualTo: podId)
            .order(by: "startTime", descending: true)
            .limit(to: limit)
            .getDocuments()

        return snap.documents.compactMap { SessionResult(from: $0.data()) }
    }
}
