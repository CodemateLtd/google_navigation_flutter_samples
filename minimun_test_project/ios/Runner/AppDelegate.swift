import Flutter
import GoogleNavigation
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // 1. Try to find the Maps API key from the environment variables.
    // 2. Try to find the Maps API key from the Dart defines.
    // 3. Use the default Maps API key "YOUR_API_KEY".
    var mapsApiKey =
      ProcessInfo.processInfo.environment["MAPS_API_KEY"] ?? findMapApiKeyFromDartDefines(
        "MAPS_API_KEY") ?? ""
    if mapsApiKey.isEmpty {
      mapsApiKey = "YOUR_API_KEY"
    }
    if mapsApiKey.isEmpty || mapsApiKey == "YOUR_API_KEY" {
      fatalError(
        "Google Maps API key not provided. Pass it with --dart-define=MAPS_API_KEY=<api-key>")
    }
    GMSServices.provideAPIKey(mapsApiKey)
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Helper function to find the Maps API key from the Dart defines
  private func findMapApiKeyFromDartDefines(_ defineKey: String) -> String? {
    if Bundle.main.infoDictionary!["DART_DEFINES"] == nil {
      return nil
    }

    let dartDefinesString = Bundle.main.infoDictionary!["DART_DEFINES"] as! String
    let base64EncodedDartDefines = dartDefinesString.components(separatedBy: ",")
    for base64EncodedDartDefine in base64EncodedDartDefines {
      let decoded = String(data: Data(base64Encoded: base64EncodedDartDefine)!, encoding: .utf8)!
      let values = decoded.components(separatedBy: "=")
      if values[0] == defineKey && values.count == 2 {
        return values[1]
      }
    }
    return nil
  }
}
