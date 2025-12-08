import UIKit
import Flutter
import isometrik_call_flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        IsometrikCallFlutterPlugin.setupWithAppDelegate(
            application,
            window: window,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}