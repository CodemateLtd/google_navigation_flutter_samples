# Google Navigation Flutter Test Project

This project demonstrates the implementation of Google Navigation Flutter package for iOS to test navigation session and guidance features.

## Features Implemented

- ✅ Initialize navigation session
- ✅ Request location permissions
- ✅ Show terms and conditions dialog
- ✅ Set navigation destinations
- ✅ Start navigation guidance
- ✅ Stop navigation guidance
- ✅ Cleanup navigation session

## Requirements

- Flutter SDK
- iOS 16.0+ (required by google_navigation_flutter)
- Xcode with iOS development tools
- Google Maps API Key

## Setup

1. **Get a Google Maps API Key:**
   - Visit the [Google Cloud Console](https://console.cloud.google.com/)
   - Create a new project or select an existing one
   - Enable the following APIs:
     - Maps SDK for iOS
     - Navigation SDK for iOS
   - Create credentials and get your API key
   - Apply API restrictions to limit usage to "Navigation SDK" and "Maps SDK for iOS"

2. **Add your API Key:**
   - Open `ios/Runner/AppDelegate.swift`
   - Replace `YOUR_API_KEY_HERE` with your actual Google Maps API key

3. **iOS Location Permissions:**
   - The app requires "Always" location permission for navigation
   - When prompted, tap "Allow While Using App" first, then go to Settings > Privacy & Security > Location Services > [Your App] and select "Always"
   - Required Info.plist entries are already configured:
     - `NSLocationWhenInUseUsageDescription`
     - `NSLocationAlwaysAndWhenInUseUsageDescription` 
     - `NSLocationAlwaysUsageDescription` (for background navigation)
     - `UIBackgroundModes` with "location" capability

4. **Install dependencies:**
   ```bash
   flutter pub get
   ```

5. **Build and run:**
   ```bash
   flutter run
   ```

## Project Structure

- `lib/main.dart` - Main application with navigation test UI
- `ios/Podfile` - iOS dependencies configuration (iOS 16.0+)
- `ios/Runner/Info.plist` - iOS permissions and background modes
- `ios/Runner/AppDelegate.swift` - Google Maps API key configuration
- `ios/Runner.xcworkspace/xcshareddata/swiftpm/Package.resolved` - Swift Package Manager resolved packages

## Usage

1. **Initialize Navigation Session:**
   - Tap "Initialize Navigation Session"
   - Grant location permissions when prompted
   - Accept terms and conditions if shown

2. **Start Navigation:**
   - After initialization, tap "Start Navigation to Sample Location"
   - This will set a destination (Google HQ) and start guidance
   - Navigation runs in the background without showing a map view

3. **Stop Navigation:**
   - Tap "Stop Navigation" to stop guidance
   - Navigation session remains active

4. **Cleanup:**
   - Tap "Cleanup Navigation" to completely clean up the session

## Key Implementation Details

- Uses `google_navigation_flutter: ^0.6.4`
- iOS-only implementation (no Android support)
- Background navigation without map view
- Proper permission handling for iOS
- Swift Package Manager for dependencies (no CocoaPods needed)

## Note

This is a test implementation to isolate iOS-specific navigation issues. The actual navigation guidance runs in the background without displaying a map interface.

## Troubleshooting

### "Failed to initialize navigation: no permissions granted"

This error occurs when the app doesn't have the required location permissions. To fix:

1. **Grant Location Permissions:**
   - When first running the app, you'll see permission dialogs
   - Tap "Allow While Using App" when prompted
   - Then go to iOS Settings > Privacy & Security > Location Services > [Your App Name]
   - Select "Always" (not just "While Using App")

2. **Verify Permissions:**
   - The app will show current permission status in the status text
   - You should see "When in use: granted, Always: granted" for navigation to work

3. **Reset Permissions (if needed):**
   - Go to Settings > General > Transfer or Reset iPhone > Reset > Reset Location & Privacy
   - Or delete and reinstall the app to reset permissions

### "Route Status: locationUnavailable"

This means the device hasn't acquired a GPS location yet. Wait a few moments for location services to initialize, especially when testing indoors or in areas with poor GPS signal.
