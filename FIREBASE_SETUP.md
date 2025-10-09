# Firebase Setup Guide for FaceDown

## 1. Add Firebase SDK via Swift Package Manager

1. Open your project in Xcode
2. Go to **File → Add Package Dependencies...**
3. Enter the Firebase SDK URL: `https://github.com/firebase/firebase-ios-sdk`
4. Select version **11.0.0** or later
5. Add the following packages:
   - **FirebaseAuth**
   - **FirebaseFirestore**
   - **FirebaseCore**

## 2. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project (or select existing)
3. Add an iOS app to your project:
   - Bundle ID: `com.yourname.FaceDown` (match your Xcode bundle ID)
   - App nickname: FaceDown
   - Download the `GoogleService-Info.plist` file

## 3. Add GoogleService-Info.plist to Xcode

1. Drag the downloaded `GoogleService-Info.plist` into your Xcode project
2. Make sure "Copy items if needed" is checked
3. Add it to the **FaceDown** target

## 4. Configure Firestore Database

1. In Firebase Console, go to **Firestore Database**
2. Click **Create Database**
3. Start in **test mode** (for development)
4. Choose a location close to your users

### Security Rules (for production):
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Sessions collection
    match /sessions/{sessionId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
      allow update, delete: if request.auth != null && resource.data.userId == request.auth.uid;
    }
    
    // Pods collection
    match /pods/{podId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update: if request.auth != null && 
                       request.auth.uid in resource.data.memberIds;
    }
  }
}
```

## 5. Update Info.plist for Motion Permissions

Add the following to your `Info.plist`:

```xml
<key>NSMotionUsageDescription</key>
<string>FaceDown uses motion sensors to detect when your phone is face-down during focus sessions.</string>
```

To add this in Xcode:
1. Select `Info.plist` in the Project Navigator
2. Right-click and select **Add Row**
3. Key: `Privacy - Motion Usage Description`
4. Value: `FaceDown uses motion sensors to detect when your phone is face-down during focus sessions.`

## 6. Enable Anonymous Authentication

1. In Firebase Console, go to **Authentication**
2. Click **Get Started**
3. Go to **Sign-in method** tab
4. Enable **Anonymous** authentication

## 7. Build and Run

1. Clean build folder: **Product → Clean Build Folder** (⇧⌘K)
2. Build: **Product → Build** (⌘B)
3. Run on a real device (motion sensors don't work in simulator)

## Testing

- The app will automatically sign in anonymously on launch
- Start a focus session and place your phone face-down
- After the session ends, check Firebase Console → Firestore Database
- You should see a new document in the `sessions` collection

## Firestore Data Structure

### Sessions Collection
```
sessions/
  {sessionId}/
    - userId: String
    - podId: String? (optional)
    - startTime: Timestamp
    - endTime: Timestamp
    - durationSeconds: Number
    - faceDownPercentage: Number (0-100)
    - steadyPercentage: Number (0-100)
    - passed: Boolean
```

### Pods Collection
```
pods/
  {podId}/
    - name: String
    - creatorUserId: String
    - memberIds: Array<String>
    - createdAt: Timestamp
```

## Troubleshooting

### "No such module 'FirebaseCore'"
- Make sure Firebase packages are added via SPM
- Clean and rebuild the project

### Motion data shows 0%
- Run on a **real device** (not simulator)
- Ensure motion permissions are granted
- Check that `Info.plist` has the motion usage description

### Session not saving to Firestore
- Check Firebase Console for authentication (user should be signed in)
- Check Firestore security rules
- Look at Xcode console for error messages

## Next Steps

- Implement pod creation and joining UI
- Add user profiles
- Create leaderboard views
- Add real-time updates with Firestore listeners
- Implement push notifications for pod activity


