//
//  IsometrikCallAppDelegateHelper.swift
//  isometrik_call_flutter
//
//  Created by Rajkumar Gahane
//

import UIKit
import CallKit
import AVFAudio
import PushKit
import Flutter
import flutter_callkit_incoming

public class IsometrikCallAppDelegateHelper: NSObject, PKPushRegistryDelegate {
    
    // MARK: - Properties
    public static let shared = IsometrikCallAppDelegateHelper()
    
    private let channelName = "com.isometrik.call"
    private var methodChannel: FlutterMethodChannel?
    private var flutterEngine: FlutterEngine?
    private var ongoingCall: IncomingCall?
    private var incomingCalls = [String: IncomingCall]()
    private var pushRegistry: PKPushRegistry?
    
    // MARK: - Public Methods
    
    /// Call this method in your AppDelegate's didFinishLaunchingWithOptions
    public func setupWith(
        _ application: UIApplication,
        window: UIWindow?,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) {
        setupFlutterEngine()
        setupMethodChannel(window: window)
        setupPushKit()
    }
    
    /// Call this method in your AppDelegate if you want to handle the setup manually
    public func setupMethodChannelOnly(with controller: FlutterViewController) {
        methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: controller.binaryMessenger)
        setupMethodChannelHandler()
    }
    
    // MARK: - Private Setup Methods
    
    private func setupFlutterEngine() {
        flutterEngine = FlutterEngine(name: "io.flutter", project: nil)
    }
    
    private func setupMethodChannel(window: UIWindow?) {
        guard let controller = window?.rootViewController as? FlutterViewController else {
            print("IsometrikCall: Warning - Could not find FlutterViewController")
            return
        }
        
        methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: controller.binaryMessenger)
        setupMethodChannelHandler()
    }
    
    private func setupMethodChannelHandler() {
        methodChannel?.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: FlutterResult) in
            guard let self = self else { return }
            
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
            }
        }
    }
    
    private func setupPushKit() {
        pushRegistry = PKPushRegistry(queue: DispatchQueue.main)
        pushRegistry?.delegate = self
        pushRegistry?.desiredPushTypes = Set([.voIP])
        
        // Validate CallKit plugin availability during setup
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.validateCallKitSetup()
        }
    }
    
    private func validateCallKitSetup() {
        guard SwiftFlutterCallkitIncomingPlugin.sharedInstance != nil else {
            print("IsometrikCall: WARNING - FlutterCallkitIncomingPlugin not initialized. CallKit functionality may not work properly.")
            print("IsometrikCall: Ensure flutter_callkit_incoming plugin is properly registered in your AppDelegate.")
            return
        }
        print("IsometrikCall: CallKit plugin validation successful")
    }
    
    // MARK: - Flutter Engine Management
    
    private func startFlutterEngineIfNeeded(_ payload: PKPushPayload) {
        if flutterEngine == nil {
            flutterEngine = FlutterEngine(name: "io.flutter", project: nil)
            flutterEngine?.run()
            // Note: Plugin registration is handled by the main app's AppDelegate
        }
        
        if let flutterEngine = flutterEngine, let controller = flutterEngine.viewController {
            let channel = FlutterMethodChannel(name: channelName, binaryMessenger: controller.binaryMessenger)
            
            DispatchQueue.global().asyncAfter(deadline: .now()) {
                channel.invokeMethod("handleIncomingPush", arguments: payload.dictionaryPayload)
            }
        }
    }
    
    // MARK: - PKPushRegistryDelegate
    
    public func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        print("IsometrikCall: didUpdatePushTokenFor")
        let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
        print("IsometrikCall: didUpdatePushTokenFor \(deviceToken)")
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP(deviceToken)
    }
    
    public func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("IsometrikCall: didInvalidatePushTokenFor")
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP("")
    }
    
    public func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        print("IsometrikCall: didReceiveIncomingPushWith 1 \(payload.dictionaryPayload)")
        guard type == .voIP else { return }
        print("IsometrikCall: didReceiveIncomingPushWith 2 \(payload.dictionaryPayload)")
        handleIncomingPush(with: payload)
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            completion()
        }
    }
    
    // MARK: - Push Handling
    
    private func handleIncomingPush(with payload: PKPushPayload) {
        print("IsometrikCall: didReceiveIncomingPushWith \(payload.dictionaryPayload)")
        
        guard let metaData = payload.dictionaryPayload["metaData"] as? [String: Any] ?? payload.dictionaryPayload["payload"] as? [String: Any] else { return }
        
        let id = UUID().uuidString
        let nameCaller = "Unknown Caller"
        
        // Validate UUID format to prevent crashes
        guard UUID(uuidString: id) != nil else {
            print("IsometrikCall: ERROR - Invalid UUID generated: \(id)")
            return
        }
        
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
            "uuid": id, // Ensure UUID is properly set
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
        
        print("IsometrikCall: Creating CallKit data with UUID: \(id)")
        print("IsometrikCall: CallKit data: \(callKitData)")
        
        let data = flutter_callkit_incoming.Data(args: callKitData)
        
        data.extra = [
            "uid": id,
            "uuid": id, // Ensure UUID is also in extra data
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
    
    private func handleIncomingCalls(call: IncomingCall, payload: PKPushPayload) {
        print("IsometrikCall: handleIncomingCalls \(call.id)")
        
        incomingCalls[call.id] = call
        startRinging(call: call, payload: payload)
    }
    
    private func checkIsLoggedIn(completion: @escaping (Bool) -> Void) {
        guard let methodChannel = methodChannel else {
            print("IsometrikCall: Method channel is nil")
            completion(false)
            return
        }
        
        methodChannel.invokeMethod("checkIsUserLoggedIn", arguments: nil) { result in
            if let isLoggedIn = result as? Bool {
                print("IsometrikCall: User is logged in: \(isLoggedIn)")
                completion(isLoggedIn)
            } else if let error = result as? FlutterError {
                print("IsometrikCall: Error checking login status: \(error.message ?? "Unknown error")")
                completion(false)
            } else {
                print("IsometrikCall: Unexpected result type")
                completion(false)
            }
        }
    }
    
    private func startRinging(call: IncomingCall, payload: PKPushPayload) {
        print("IsometrikCall: startRinging \(call.id)")
        
        // Validate CallKit plugin availability before showing call
        guard let callkitPlugin = SwiftFlutterCallkitIncomingPlugin.sharedInstance else {
            print("IsometrikCall: ERROR - FlutterCallkitIncomingPlugin not available")
            handleCallKitError(for: call)
            return
        }
        
        // Show CallKit incoming call with error handling
        do {
            callkitPlugin.showCallkitIncoming(call.data, fromPushKit: true)
            print("IsometrikCall: Successfully initiated CallKit UI for call \(call.id)")
        } catch {
            print("IsometrikCall: ERROR - Failed to show CallKit incoming: \(error)")
            handleCallKitError(for: call)
            return
        }
        
        startFlutterEngineIfNeeded(payload)
        
        // Remove call after successful CallKit initiation, not before
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.removeCall(call.id)
        }
        
        checkIsLoggedIn { [weak self] result in
            guard let self = self else { return }
            if !result {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.endCallSafely(call: call)
                    self.invalidateAndReRegister()
                }
            }
        }
    }
    
    private func endCall(call: IncomingCall) {
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.endCall(call.data)
    }
    
    private func endCallSafely(call: IncomingCall) {
        guard let callkitPlugin = SwiftFlutterCallkitIncomingPlugin.sharedInstance else {
            print("IsometrikCall: WARNING - Cannot end call, CallKit plugin not available")
            return
        }
        
        do {
            callkitPlugin.endCall(call.data)
            print("IsometrikCall: Successfully ended call \(call.id)")
        } catch {
            print("IsometrikCall: ERROR - Failed to end call: \(error)")
        }
    }
    
    private func handleCallKitError(for call: IncomingCall) {
        print("IsometrikCall: Handling CallKit error for call \(call.id)")
        
        // Remove the problematic call from queue
        removeCall(call.id)
        
        // Try to process next call in queue if any
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.checkCallQueue()
        }
        
        // Notify Flutter about the failed call attempt
        DispatchQueue.main.async {
            self.methodChannel?.invokeMethod("callKitError", arguments: [
                "callId": call.id,
                "error": "CallKit provider not available - transaction failed"
            ])
        }
    }
    
    private func checkCallQueue() {
        print("IsometrikCall: checkCallQueue")
        let now = Date()
        
        for (id, call) in incomingCalls {
            print("IsometrikCall: checkCallQueue - \(id)")
            if call.expirationTime <= now {
                removeCall(id)
            } else {
                startRinging(call: call, payload: PKPushPayload())
                break
            }
        }
    }
    
    private func removeCall(_ id: String) {
        print("IsometrikCall: removeCall")
        incomingCalls.removeValue(forKey: id)
    }
    
    // MARK: - Method Channel Event Handlers
    
    private func handleRinging(_ callId: String) {
        print("IsometrikCall: Handling ringing event for: \(callId)")
    }
    
    private func handleCallDeclined(_ callId: String) {
        print("IsometrikCall: Handling call declined event for: \(callId)")
        removeCall(callId)
        checkCallQueue()
    }
    
    private func handleCallStarted(_ callId: String) {
        print("IsometrikCall: Handling call started/accepted event for: \(callId)")
        ongoingCall = incomingCalls[callId]
    }
    
    private func handleTimeout(_ callId: String) {
        print("IsometrikCall: Handling timeout event for: \(callId)")
        removeCall(callId)
        checkCallQueue()
    }
    
    private func handleCallEnd(_ callId: String) {
        print("IsometrikCall: Handling call end event for: \(callId)")
        ongoingCall = nil
        checkCallQueue()
    }
    
    // MARK: - Utility Methods
    
    private func invalidateAndReRegister() {
        print("IsometrikCall: Invalidating and re-registering push registry")
        pushRegistry = nil
        pushRegistry = PKPushRegistry(queue: DispatchQueue.main)
        pushRegistry?.delegate = self
        pushRegistry?.desiredPushTypes = [.voIP]
    }
}
