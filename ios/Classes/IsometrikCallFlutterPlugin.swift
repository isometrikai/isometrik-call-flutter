import Flutter
import UIKit

public class IsometrikCallFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.isometrik.call.plugin", binaryMessenger: registrar.messenger())
    let instance = IsometrikCallFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "setupCallHandling":
      result("Call handling setup completed")
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  /// Convenience method for easy AppDelegate integration
  /// Call this in your AppDelegate's didFinishLaunchingWithOptions
  public static func setupWithAppDelegate(
    _ application: UIApplication,
    window: UIWindow?,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    IsometrikCallAppDelegateHelper.shared.setupWith(
      application,
      window: window,
      didFinishLaunchingWithOptions: launchOptions
    )
    return true
  }
  
  /// Alternative method for manual setup with FlutterViewController
  public static func setupWithController(_ controller: FlutterViewController) {
    IsometrikCallAppDelegateHelper.shared.setupMethodChannelOnly(with: controller)
  }
}





