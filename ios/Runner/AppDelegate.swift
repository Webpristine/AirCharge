import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

    GMSServices.provideAPIKey("AIzaSyAeZBNnM4KxyAkWHjfnau9H7bCP9EqWWkc")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
