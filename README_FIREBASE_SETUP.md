# 🔥 Firebase Setup Instructions

The application ships with a `Mock` implementation to ensure it runs out-of-the-box. Follow these instructions to hook it up to a real Firebase backend.

## Prerequisites
- A Firebase Account (https://console.firebase.google.com/)
- Flutter CLI installed
- Firebase CLI installed (`npm install -g firebase-tools`)
- FlutterFire CLI installed (`dart pub global activate flutterfire_cli`)

## Step 1: Create Firebase Project
1. Go to the Firebase Console and click "Add Project". Name it `liftoff-clone`.
2. Disable Google Analytics (optional, for speed).
3. Wait for the project to provision.

## Step 2: Configure FlutterFire
In the root directory of this repository, run:

```bash
flutterfire configure --project=liftoff-clone
```

Select the platforms you wish to support (android, ios, web).
This command will automatically create the `firebase_options.dart` file and configure the native paths:
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

## Step 3: Enable Authentication & Firestore
1. In the Firebase Console, go to **Build > Authentication**.
2. Click **Get Started**, go to the **Sign-in method** tab, and enable **Anonymous**.
3. Go to **Build > Firestore Database** and click **Create database**.
4. Start in **Test mode** (or apply the security rules below).

## Step 4: Apply Firestore Security Rules
Go to the **Rules** tab in Firestore and paste the following:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow users to read/write their own workout sessions and routines
    match /workout_sessions/{sessionId} {
      allow read, write: if request.auth != null && request.auth.uid == resource.data.userId;
      // Allow create if the userId matches the authenticated user
      allow create: if request.auth != null && request.auth.uid == request.resource.data.userId;
    }

    match /routines/{routineId} {
      allow read, write: if request.auth != null && request.auth.uid == resource.data.userId;
      allow create: if request.auth != null && request.auth.uid == request.resource.data.userId;
    }

    match /personal_records/{recordId} {
      allow read, write: if request.auth != null && request.auth.uid == resource.data.userId;
      allow create: if request.auth != null && request.auth.uid == request.resource.data.userId;
    }

    // Leaderboards are public to read, but updates should ideally be handled via Cloud Functions.
    // For this prototype, we allow authenticated users to update their own volume.
    match /leaderboards/{userId} {
      allow read: if true; // Public leaderboard
      allow write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Step 5: Toggle the Implementation in Code

To switch from Mock data to Firebase, update the repository providers.

1. Open `lib/main.dart` and uncomment the Firebase initialization:
```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: LiftoffApp()));
}
```

2. Open `lib/providers/workout_providers.dart` and `lib/providers/leaderboard_providers.dart` and change the return statement in the providers to use the Firebase classes instead:

```dart
// Example in leaderboard_providers.dart:
import 'package:app/repositories/firebase_leaderboard_repository.dart';

final leaderboardRepositoryProvider = Provider<LeaderboardRepository>((ref) {
  return FirebaseLeaderboardRepository();
});
```

Rebuild and run the app, and you're fully connected to the cloud!
