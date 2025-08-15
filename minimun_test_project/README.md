
# Google Navigation Flutter iOS Test

Minimal test project for the `google_navigation_flutter` package on iOS.

## Requirements

- Flutter SDK
- iOS 16.0+
- Xcode
- Google Maps API Key

## Setup

1. **Get a Google Maps API Key**
   - Enable Maps SDK for iOS and Navigation SDK for iOS in [Google Cloud Console](https://console.cloud.google.com/)
   - Create an API key and restrict it to these SDKs

2. **Pass the API key to the app**
      - Run the app with:
         ```sh
         flutter run --dart-define=MAPS_API_KEY=YOUR_API_KEY
         ```
      - The iOS code will read this value at runtime. If not provided, the app will fail to start.

3. **Install dependencies**
   ```sh
   flutter pub get
   ```

4. **Location permissions**
   - The app requires "Always" location permission for navigation.
   - When prompted, allow location access, then set to "Always" in iOS Settings if needed.
   - All required Info.plist entries are preconfigured.

## Usage

1. Tap "Initialize Navigation Session" and grant permissions.
2. Tap "Start Navigation to Sample Location" to begin background navigation.
3. Tap "Stop Navigation" to stop guidance.
4. Tap "Cleanup Navigation" to end the session.

## Notes

- iOS only. No Android support.
- No map view is shown; navigation runs in the background.
- API key is never hardcoded—always passed via `--dart-define`.
- See `ios/Runner/AppDelegate.swift` for how the API key is read from Dart defines and decoded.
