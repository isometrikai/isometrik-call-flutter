import Flutter
import UIKit
import CallKit
import PushKit
import AVFAudio
import flutter_callkit_incoming

typealias EngineInitializer = (_ engine: FlutterEngine, _ payload: PKPushPayload)  -> Void


public class IsometrikCallFlutterPlugin: NSObject, FlutterPlugin, PKPushRegistryDelegate {
    
    let channel = "com.isometrik.call"
    
    var flutterEngine: FlutterEngine?
    
    var ongoingCall: IncomingCall?
    var incomingCalls = [String: IncomingCall]()
    
    var pushRegistry: PKPushRegistry?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = IsometrikCallFlutterPlugin()
        let channel = FlutterMethodChannel(name: instance.channel, binaryMessenger: registrar.messenger())

        registrar.addMethodCallDelegate(instance, channel: channel)
        
        // Set up PushKit registry
        instance.pushRegistry = PKPushRegistry(queue: DispatchQueue.main)
        instance.pushRegistry?.delegate = instance
        instance.pushRegistry?.desiredPushTypes = Set([.voIP])
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
              let callId = arguments["callId"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing or invalid arguments", details: nil))
            return
        }
        
        switch call.method {
        case "handleRinging":
            handleRinging(callId)
            result(nil)
        case "handleCallDeclined":
            handleCallDeclined(callId)
            result(nil)
        case "handleCallStarted":
            handleCallStarted(callId)
            result(nil)
        case "handleTimeout":
            handleTimeout(callId)
            result(nil)
        case "handleCallEnd":
            handleCallEnd(callId)
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    func startFlutterEngineIfNeeded(_ payload: PKPushPayload) {
        if flutterEngine == nil {
            flutterEngine = FlutterEngine(name: "io.flutter", project: nil)
            flutterEngine?.run()
            GeneratedPluginRegistrant.register(with: flutterEngine!)
        }
        
        if let flutterEngine = flutterEngine, let controller = flutterEngine.viewController {
            let channel = FlutterMethodChannel(name: self.channel, binaryMessenger: controller.binaryMessenger)
            
            DispatchQueue.global().asyncAfter(deadline: .now()) {
                channel.invokeMethod("handleIncomingPush", arguments: payload.dictionaryPayload)
            }
        }
    }
    
    // ------- PKPushRegistryDelegate Functions --------
    
    public func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        print("didUpdatePushTokenFor")
        let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP(deviceToken)
    }
    
    public func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("didInvalidatePushTokenFor")
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP("")
    }
    
    public func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        guard type == .voIP else { return }
        
        self.handleIncomingPush(with: payload)
        
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
        
        let meetingId = payload.dictionaryPayload["meetingId"] as? String ?? ""
        
        let type = payload.dictionaryPayload["meetingType"] as? Int ?? 0
        
        let name = payload.dictionaryPayload["initiatorName"] as? String ?? nameCaller
        let identifier = payload.dictionaryPayload["initiatorIdentifier"] as? String ?? handle
        let userId = payload.dictionaryPayload["identifier"] as? String ?? ""
        let imageUrl = payload.dictionaryPayload["initiatorImageUrl"] as? String ?? ""
        
        let callKitData = [
            "id": id,
            "nameCaller": name,
            "handle": identifier,
            "type": type,
            "avatar": imageUrl,
            "maximumCallsPerCallGroup": 1,
            "maximumCallGroups": 1,
            "iconName": "AppIcon",
            "appName": "Hola",
        ] as [String : Any]
        
        let data = flutter_callkit_incoming.Data(args: callKitData)
        
        data.extra = [
            "uid": id,
            "id": meetingId,
            "meetingId": meetingId,
            "name": name,
            "imageUrl": imageUrl,
            "userIdentifier": identifier,
            "userId": userId,
            "platform": "ios",
        ]
        
        let call = IncomingCall(id: id, data: data, expirationTime: Date().addingTimeInterval(TimeInterval(30)))
        
        handleIncomingCalls(call: call, payload: payload)
    }
    
    func handleIncomingCalls(call: IncomingCall, payload: PKPushPayload) {
        print("LOG: handleIncomingCalls \(call.id)")
        
        startRinging(call: call, payload: payload)
        
        incomingCalls[call.id] = call
    }
    
    func startRinging(call: IncomingCall, payload: PKPushPayload) {
        print("LOG: startRinging \(call.id)")
        removeCall(call.id)
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming(call.data, fromPushKit: true)
        startFlutterEngineIfNeeded(payload)
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
        print("LOG: Handling ringing event for: \(callId)")
    }
    
    func handleCallDeclined(_ callId: String) {
        print("LOG: Handling call declined event for: \(callId)")
        removeCall(callId)
        checkCallQueue()
    }
    
    func handleCallStarted(_ callId: String) {
        print("LOG: Handling call started/accepted event for: \(callId)")
        ongoingCall = incomingCalls[callId]
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






