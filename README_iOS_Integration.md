# iOS Integration Guide for Isometrik Call Flutter Plugin

This guide shows how to integrate the Isometrik Call Flutter plugin with minimal code in your iOS AppDelegate.

## 🚀 Quick Setup

### Option 1: Automatic Setup (Recommended)

Replace your existing `AppDelegate.swift` with this minimal code:

```swift
import UIKit
import Flutter
import isometrik_call_flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Setup Isometrik Call handling automatically
        IsometrikCallFlutterPlugin.setupWithAppDelegate(
            application,
            window: window,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        // Register other plugins
        GeneratedPluginRegistrant.register(with: self)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
```

### Option 2: Manual Setup

If you need more control or have custom setup requirements:

```swift
import UIKit
import Flutter
import isometrik_call_flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Your existing setup code...
        GeneratedPluginRegistrant.register(with: self)
        
        // Setup Isometrik Call with your FlutterViewController
        if let controller = window?.rootViewController as? FlutterViewController {
            IsometrikCallFlutterPlugin.setupWithController(controller)
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
```

## 📋 Requirements

1. **iOS Deployment Target**: Minimum iOS 12.0
2. **Dependencies**: The plugin automatically includes:
   - `CallKit` framework
   - `AVFoundation` framework  
   - `PushKit` framework
   - `flutter_callkit_incoming` dependency

## 🔧 What the Plugin Handles Automatically

- ✅ VoIP push notifications setup
- ✅ CallKit integration
- ✅ Incoming call handling
- ✅ Call state management
- ✅ Push token registration
- ✅ Flutter method channel setup
- ✅ Background call processing
- ✅ Call queue management
- ✅ User authentication checks

## 🎯 Method Channel Events

The plugin automatically handles these method channel calls from your Flutter app:

- `handleRinging` - When call starts ringing
- `handleCallDeclined` - When user declines call
- `handleCallStarted` - When user accepts call
- `handleTimeout` - When call times out
- `handleCallEnd` - When call ends
- `checkIsUserLoggedIn` - To verify user authentication

## 📱 Required Permissions

Make sure your `Info.plist` includes:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>voip</string>
    <string>background-processing</string>
</array>
```

## 🔄 Migration from Manual Implementation

If you're migrating from a manual AppDelegate implementation:

1. **Backup** your current `AppDelegate.swift`
2. **Replace** with the minimal code shown in Option 1 above
3. **Remove** any existing VoIP/CallKit setup code
4. **Test** that calls still work as expected

## 🐛 Troubleshooting

### Issue: Calls not showing up
- Ensure you've added the `UIBackgroundModes` to Info.plist
- Check that VoIP certificate is properly configured
- Verify the plugin is initialized in `didFinishLaunchingWithOptions`

### Issue: Method channel errors
- Make sure `GeneratedPluginRegistrant.register(with: self)` is called
- Verify the Flutter app is properly implementing the method channel responses

### Issue: Build errors
- Clean and rebuild your project
- Ensure iOS deployment target is 12.0 or higher
- Check that all required frameworks are linked

## 📞 Support

If you encounter any issues with the integration, please check:

1. iOS deployment target (minimum 12.0)
2. Required permissions in Info.plist
3. VoIP certificate configuration
4. Plugin initialization in AppDelegate

The plugin logs all operations with `IsometrikCall:` prefix for easy debugging.

---

This integration reduces your AppDelegate code from ~290 lines to just ~20 lines while maintaining all functionality! 🎉
