# Google Navigation Flutter Samples

This repository contains sample implementations and test projects for Google Navigation Flutter SDK.

## Projects

### ios_test/
iOS-specific test project demonstrating Google Navigation Flutter SDK integration for iOS. This project focuses on testing navigation session initialization, guidance features, and background navigation without map view display.

**Key Features:**
- Navigation session management
- Location permission handling
- Terms and conditions flow
- Background navigation guidance
- iOS 16.0+ compatibility

**Setup:**
```bash
cd ios_test
flutter pub get
# Add your Google Maps API key to ios/Runner/AppDelegate.swift
flutter run
```

## Requirements

- Flutter SDK
- Google Maps API Key with Navigation SDK enabled
- iOS development environment (for ios_test)

## Getting Started

1. Clone this repository
2. Navigate to the specific project folder
3. Follow the setup instructions in each project's README
4. Add your Google Maps API key
5. Run the project

## API Key Setup

Each project requires a Google Maps API Key with the following APIs enabled:
- Maps SDK for iOS/Android
- Navigation SDK for iOS/Android

Refer to individual project READMEs for specific setup instructions.
