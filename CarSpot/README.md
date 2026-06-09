# CarSpot

A native iOS app for spotting and collecting cars, built for two.

## Features

- Photograph cars you spot and identify them with Gemini AI
- Browse your collection with make/model/year details
- View each car on Apple Maps where you spotted it
- Interesting AI-generated facts for every car
- Stats dashboard: most spotted make, rarest find, monthly totals
- Multiple photos per car
- Firebase sync between devices
- iOS 18+ with Liquid Glass styling on iOS 26

## Setup

### Prerequisites

- macOS with Xcode 16+
- [xcodegen](https://github.com/yonaskolb/XcodeGen): `brew install xcodegen`
- A [Firebase](https://firebase.google.com) project
- A [Google AI Studio](https://aistudio.google.com) API key (Gemini)

### 1. Firebase

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Add an iOS app with bundle ID `com.carspot.app`
3. Download `GoogleService-Info.plist` and place it in `CarSpot/` (alongside `Info.plist`)
4. Enable **Firestore** and **Storage** in the Firebase console
5. Enable **Anonymous Authentication** under Authentication → Sign-in method

**Firestore security rules** — paste these into the Rules tab:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/cars/{carId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

**Storage security rules:**
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 2. Gemini API Key

Open `CarSpot/Config.swift` and replace `YOUR_GEMINI_API_KEY` with your key from [Google AI Studio](https://aistudio.google.com/app/apikey).

### 3. Generate Xcode Project

```bash
cd CarSpot
xcodegen generate
```

### 4. Open and Build

```bash
open CarSpot.xcodeproj
```

- Set your Development Team in Signing & Capabilities
- Select your device or simulator
- Build and run (⌘R)

## Architecture

```
CarSpot/
├── Models/          Car, CarMake
├── Data/            CarMakesData (all makes + models)
├── Services/        FirebaseService, GeminiService, LocationService
├── ViewModels/      HomeViewModel, MyCarsViewModel, AddCarViewModel
└── Views/
    ├── Home/        Stats dashboard
    ├── MyCars/      Collection list + detail
    ├── AddCar/      Camera → confirm → details flow
    └── Friends/     Coming soon
```

- **State management:** `@Observable` (iOS 17+)
- **Data:** Firebase Firestore + Storage, anonymous auth per device
- **AI:** Google Gemini 1.5 Flash (vision + text)
- **Location:** CoreLocation, Apple Maps (MapKit)
