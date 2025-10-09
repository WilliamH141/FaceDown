# FaceDown Dependencies

## Swift Package Manager Dependencies

Add these packages in Xcode via **File → Add Package Dependencies**:

### 1. Firebase iOS SDK
**URL:** `https://github.com/firebase/firebase-ios-sdk`  
**Version:** 11.0.0 or later  
**Required Products:**
- `FirebaseAuth`
- `FirebaseCore`
- `FirebaseFirestore`

---

## Xcode Project Settings

### Minimum Deployment Target
- **iOS 17.0** or later

### Required Capabilities
- **CoreMotion** (automatically included)
- **Network** access for Firebase

### Info.plist Requirements
```xml
<key>NSMotionUsageDescription</key>
<string>FaceDown uses motion sensors to detect when your phone is face-down during focus sessions.</string>
```

---

## Build Configuration

### Debug Configuration
- Enable Firebase debug logging (optional):
  - Add `-FIRDebugEnabled` to **Edit Scheme → Run → Arguments → Arguments Passed On Launch**

### Release Configuration
- Ensure Firebase analytics collection is configured per your privacy policy

---

## File Checklist

Ensure these files are in your project:

- ✅ `GoogleService-Info.plist` (from Firebase Console)
- ✅ `Info.plist` (with motion permissions)
- ✅ `FaceDownApp.swift` (Firebase initialization)
- ✅ `FirebaseService.swift` (Firebase operations)
- ✅ `SessionResult.swift` (data model)
- ✅ `MotionManager.swift` (CoreMotion handling)
- ✅ `FocusView.swift` (main timer UI)
- ✅ `ContentView.swift` (home screen)

---

## Testing on Device

### Required Hardware
- iPhone with motion sensors (gyroscope + accelerometer)
- All modern iPhones support these sensors

### Simulator Limitations
- ⚠️ **Motion sensors don't work in iOS Simulator**
- Must test on a real device

---

## Firestore Collections Structure

### sessions
```
Document ID: Auto-generated
Fields:
  - userId: string
  - podId: string | null
  - startTime: timestamp
  - endTime: timestamp
  - durationSeconds: number
  - faceDownPercentage: number
  - steadyPercentage: number
  - passed: boolean
```

### pods (for future implementation)
```
Document ID: Auto-generated
Fields:
  - name: string
  - creatorUserId: string
  - memberIds: array<string>
  - createdAt: timestamp
```

---

## Firebase Configuration Verification

After setup, verify Firebase is working:

1. Run the app on a device
2. Check Xcode console for:
   ```
   ✅ Signed in anonymously: [user-id]
   ```
3. Complete a test session (5 min)
4. Check console for:
   ```
   ✅ Session saved: [session-id]
      Duration: X.X min
      Face Down: XX.X%
      Steady: XX.X%
      Passed: true/false
   ```
5. Verify in Firebase Console → Firestore Database → sessions collection

---

## Common Issues

### "No such module 'FirebaseCore'"
**Solution:** Clean build folder (⇧⌘K) and rebuild

### "Motion data not updating"
**Solution:** Run on real device, check motion permissions

### "Failed to save session"
**Solution:** Check Firebase authentication and Firestore rules

### "GoogleService-Info.plist not found"
**Solution:** Download from Firebase Console and add to Xcode project

---

## Production Checklist

Before releasing to App Store:

- [ ] Update Firestore security rules
- [ ] Configure Firebase App Check
- [ ] Test on multiple device types
- [ ] Add privacy policy for motion data
- [ ] Configure proper bundle ID
- [ ] Test offline behavior
- [ ] Add error handling for network failures
- [ ] Implement data retention policies


