import Foundation
import FirebaseFirestore // for Timestamp

struct SessionResult: Codable {
    let userId: String
    let podId: String?
    let startTime: Date
    let endTime: Date
    let durationSeconds: Int
    let faceDownPercentage: Double
    let steadyPercentage: Double
    let passed: Bool

    var durationMinutes: Double { Double(durationSeconds) / 60.0 }

    var dictionary: [String: Any] {
        [
            "userId": userId,
            "podId": podId as Any,
            "startTime": startTime,
            "endTime": endTime,
            "durationSeconds": durationSeconds,
            "faceDownPercentage": faceDownPercentage,
            "steadyPercentage": steadyPercentage,
            "passed": passed
        ]
    }

    // Build from Firestore document data
    init?(from data: [String: Any]) {
        guard
            let userId = data["userId"] as? String,
            let durationSeconds = data["durationSeconds"] as? Int,
            let faceDown = data["faceDownPercentage"] as? Double,
            let steady = data["steadyPercentage"] as? Double,
            let passed = data["passed"] as? Bool
        else { return nil }

        // Dates can be Date or Timestamp depending on how they were written
        func date(_ any: Any?) -> Date? {
            if let d = any as? Date { return d }
            if let ts = any as? Timestamp { return ts.dateValue() }
            return nil
        }

        guard
            let start = date(data["startTime"]),
            let end = date(data["endTime"])
        else { return nil }

        self.userId = userId
        self.podId = data["podId"] as? String
        self.startTime = start
        self.endTime = end
        self.durationSeconds = durationSeconds
        self.faceDownPercentage = faceDown
        self.steadyPercentage = steady
        self.passed = passed
    }

    init(userId: String, podId: String? = nil, startTime: Date, endTime: Date,
         durationSeconds: Int, faceDownPercentage: Double, steadyPercentage: Double, passed: Bool) {
        self.userId = userId
        self.podId = podId
        self.startTime = startTime
        self.endTime = endTime
        self.durationSeconds = durationSeconds
        self.faceDownPercentage = faceDownPercentage
        self.steadyPercentage = steadyPercentage
        self.passed = passed
    }
}
