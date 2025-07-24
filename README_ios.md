# Isometrik Flutter Call SDK

## iOS

### Make these changes to your `info.plist`

Path: `ios` > `Runner` > `AppDelegate.swift`

```swift

import UIKit
import CallKit
import AVFAudio
import PushKit
import Flutter
import flutter_callkit_incoming

@main
@objc class AppDelegate: FlutterAppDelegate, PKPushRegistryDelegate {
    let channel = "com.isometrik.call"

    var flutterEngine: FlutterEngine?

    var ongoingCall: IncomingCall?
    var incomingCalls = [String: IncomingCall]()

    var pushRegistry: PKPushRegistry?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        flutterEngine = FlutterEngine(name: "io.flutter", project: nil)

        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let methodChannel = FlutterMethodChannel(name: channel, binaryMessenger: controller.binaryMessenger)

        methodChannel.setMethodCallHandler({
           (call: FlutterMethodCall, result: FlutterResult) -> Void in
            guard let arguments = call.arguments as? [String: Any],
                let callId = arguments["callId"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing or invalid arguments", details: nil))
                return
            }

           switch call.method {
           case "handleRinging":
               self.handleRinging(callId)
               result(nil)

           case "handleCallDeclined":
               self.handleCallDeclined(callId)
               result(nil)

           case "handleCallStarted":
               self.handleCallStarted(callId)
               result(nil)

           case "handleTimeout":
               self.handleTimeout(callId)
               result(nil)

           case "handleCallEnd":
               self.handleCallEnd(callId)
               result(nil)

           default:
               result(FlutterMethodNotImplemented)
               return
           }
       })

        GeneratedPluginRegistrant.register(with: self)

        // Initialize PushKit registry
        pushRegistry = PKPushRegistry(queue: DispatchQueue.main)
        pushRegistry?.delegate = self
        pushRegistry?.desiredPushTypes = Set([.voIP])

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func startFlutterEngineIfNeeded(_ payload: PKPushPayload) {
        if flutterEngine == nil {
            flutterEngine = FlutterEngine(name: "io.flutter", project: nil)
            flutterEngine?.run()
            GeneratedPluginRegistrant.register(with: flutterEngine!)
        }

        if let flutterEngine = flutterEngine, let controller = flutterEngine.viewController {
            let channel = FlutterMethodChannel(name: channel, binaryMessenger: controller.binaryMessenger)

            DispatchQueue.global().asyncAfter(deadline: .now()) {
                channel.invokeMethod("handleIncomingPush", arguments: payload.dictionaryPayload)
            }
        }
    }

    // ------- PKPushRegistryDelegate Functions --------

    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        print("didUpdatePushTokenFor")
        let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP(deviceToken)
    }

    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("didInvalidatePushTokenFor")
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP("")
    }

    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        guard type == .voIP else { return }

        self.handleIncomingPush(with: payload);

        DispatchQueue.main.asyncAfter(deadline: .now()) {
            completion()
        }
    }

    // ------- Custom Functions --------

    func handleIncomingPush(with payload: PKPushPayload) {
        print("didReceiveIncomingPushWith \(payload.dictionaryPayload)")

        guard let metaData = payload.dictionaryPayload["metaData"] as? [String: Any] ?? payload.dictionaryPayload["payload"] as? [String: Any] else { return }

        let id = UUID().uuidString
        let nameCaller = "Unknown Caller"
        let handle = "Unknown Handle"

        let ip = metaData["ip"] as? String ?? ""
        let meetingId = payload.dictionaryPayload["meetingId"] as? String ?? metaData["meetingId"] as? String ?? ""
        let isVideo = payload.dictionaryPayload["audioOnly"] as? Int ?? 0

        let callType = metaData["callType"] as? String ?? ""
        let type = callType == "video" ? 1 : 0

        let userInfo = metaData["userInfo"] as? [String: Any]
        let name = userInfo?["userName"] as? String ?? metaData["countryName"] as? String ?? nameCaller
        let userId = userInfo?["userId"] as? String ?? ""
        let userIdentifier = userInfo?["userIdentifier"] as? String ?? ""
        let imageUrl = userInfo?["userProfileImageUrl"] as? String ?? ""

        let callData = metaData["chatQwikConfig"] as? [String: Any]
        let dispatchMethod = callData?["dispatchMethod"] as? String ?? ""
        let duration = (dispatchMethod == "broadcast" ? (callData?["timeToAcceptCallInSec"] as? Int ?? 30) : (callData?["totalDispatchTimeInSec"] as? Int ?? 30)) * 1000

        let callKitData = [
            "id": id,
            "nameCaller": name,
            "handle": name,
            "type": type,
            "duration": duration,
            "avatar": imageUrl,
            "maximumCallsPerCallGroup": 1,
            "maximumCallGroups": 1,
            "iconName": "CallLogo",
            "appName": "CallQwik",
        ] as [String : Any]

        let data = flutter_callkit_incoming.Data(args: callKitData)

        data.extra = [
            "uid": id,
            "id": meetingId,
            "meetingId": meetingId,
            "name": name,
            "imageUrl": imageUrl,
            "ip": ip,
            "userIdentifier": userIdentifier,
            "userId": userId,
            "callType": callType,
            "platform": "ios",
        ]

        let call = IncomingCall(id: id, data: data, expirationTime: Date().addingTimeInterval(TimeInterval(duration / 1000)))

        handleIncomingCalls(call: call, payload: payload)
    }

    func handleIncomingCalls(call: IncomingCall, payload: PKPushPayload) {
        print("LOG: handleIncomingCalls \(call.id)")
//        if ongoingCall == nil && incomingCalls.isEmpty {
//            startRinging(call: call, payload: payload)
//        }

        incomingCalls[call.id] = call

        startRinging(call: call, payload: payload)
    }

    func startRinging(call: IncomingCall, payload: PKPushPayload) {
        print("LOG: startRinging \(call.id)")
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming(call.data, fromPushKit: true)
        startFlutterEngineIfNeeded(payload)
        removeCall(call.id)
    }

    func checkCallQueue() {
        print("LOG: checkCallQueue")
        let now = Date()

        for (id, call) in incomingCalls {
            print("LOG: checkCallQueue - \(id)")
            if call.expirationTime <= now {
                removeCall(id)
            } else {
                startRinging(call: call, payload: PKPushPayload())
                break
            }
        }
    }

    func removeCall(_ id: String) {
        print("LOG: removeCall")
        incomingCalls.removeValue(forKey: id)
    }

    // ------- Method Channel Functions --------

    func handleRinging(_ callId: String) {
        // Implement your handling for ringing event in iOS
        print("LOG: Handling ringing event for: \(callId)")
    }

    func handleCallDeclined(_ callId: String) {
        print("LOG: Handling call declined event for: \(callId)")
        removeCall(callId)
        checkCallQueue()
    }

    func handleCallStarted(_ callId: String) {
        print("LOG: Handling call started/accepted event for: \(callId)")
        ongoingCall = incomingCalls[callId];
    }

    func handleTimeout(_ callId: String) {
        print("LOG: Handling timeout event for: \(callId)")
        removeCall(callId)
        checkCallQueue()
    }

    func handleCallEnd(_ callId: String) {
        print("LOG: Handling call end event for: \(callId)")
        ongoingCall = nil
        checkCallQueue()
    }
}
```

---

### Make these changes to your project level `IncomingCallModel.swift`

### First you need make one file with `IncomingCallModel.swift` file name

Path: `ios` > `Runner` > `IncomingCallModel.swift`

You can create this file with the help of `Xcode`

1. Add code inside

```swift
//
//  IncomingCallModel.swift
//  Runner
//
//  Created by Jatin on 19/06/24.
//
import Foundation
import flutter_callkit_incoming

class IncomingCall {
    let id: String
    let data: flutter_callkit_incoming.Data
    let expirationTime: Date

    init(id: String, data: flutter_callkit_incoming.Data, expirationTime: Date) {
        self.id = id
        self.data = data
        self.expirationTime = expirationTime
    }

    open func toJSON() -> [String: Any] {
        return [
            "id": id,
            "data": data.extra,
            "expirationTime": expirationTime,
        ];
    }
}
```

Setup other platforms

- [Android](./README_andriod.md)

[Go back to main](./README.md)
