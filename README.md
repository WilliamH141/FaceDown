# FaceDown 📱

**FaceDown** is an iOS app (built with SwiftUI) that helps you stay focused by placing your phone face-down.  
If you pick up or move your device during a focus session, the app can detect it and break the streak.  
The goal is to reduce distractions and build accountability — especially when working or studying with friends.

---

## 🚀 Features

### ✅ Implemented
- **CoreMotion Integration** - Real-time face-down and steady detection
- **Focus Timer** - Countdown timer with multiple session durations (5, 25, 50 minutes)
- **Session Tracking** - Tracks faceDown% and steady% throughout sessions
- **Firebase/Firestore** - Cloud storage for session results
- **Anonymous Authentication** - Automatic sign-in for quick start
- **Results Screen** - Beautiful pass/fail UI with detailed stats
- **Modern SwiftUI** - Clean, production-quality interface

### ⏳ Coming Soon
- Pods (join focus groups with friends)
- Real-time leaderboards
- Streaks and achievements
- Push notifications
- User profiles
- Social features

---

## 🛠 Tech Stack
- **Language:** Swift 5.9+
- **UI Framework:** SwiftUI
- **IDE:** Xcode 16+
- **Backend:** Firebase (Firestore, Auth)
- **Sensors:** CoreMotion (Accelerometer + Gyroscope)
- **Version Control:** Git + GitHub

---

## 📦 Getting Started

### Prerequisites
- Xcode 16 or later
- iOS 17.0+ target device (motion sensors required)
- Firebase account

### Setup
1. Clone this repo:
   ```bash
   git clone https://github.com/WilliamH141/FaceDown.git
   ```

2. Follow the Firebase setup guide in [`FIREBASE_SETUP.md`](FIREBASE_SETUP.md)

3. Open `FaceDown.xcodeproj` in Xcode

4. Build and run on a **real device** (simulator doesn't support motion sensors)

---

## 🎯 How It Works

1. **Start a Session** - Choose 5, 25, or 50 minute focus session
2. **Place Phone Face-Down** - Put your phone face-down on a stable surface
3. **Stay Focused** - The app monitors:
   - Face-down orientation (via accelerometer)
   - Steady state (via gyroscope)
4. **View Results** - After session ends, see your stats:
   - Pass if **≥80% face down** AND **≥70% steady**
   - Fail otherwise

---

## 📊 Session Criteria

| Metric | Threshold | Description |
|--------|-----------|-------------|
| Face Down % | ≥ 80% | Phone must be face-down |
| Steady % | ≥ 70% | Phone must remain still |
| Duration | Full session | Complete the timer |

---

## 📱 Screenshots

*Coming soon*

---

## 🤝 Contributing

Contributions are welcome! Feel free to submit issues or pull requests.

---

## 📄 License

MIT License - see LICENSE file for details
