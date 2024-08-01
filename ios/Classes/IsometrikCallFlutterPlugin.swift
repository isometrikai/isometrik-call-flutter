import Flutter
import UIKit
import CallKit
import AVFAudio
import PushKit
import flutter_callkit_incoming


public class IsometrikCallFlutterPlugin: NSObject, FlutterPlugin, PKPushRegistryDelegate {
  private let channel = "com.isometrik.call"
  private var flutterEngine: FlutterEngine?
  private var ongoingCall: IncomingCall?
  private var incomingCalls = [String: IncomingCall]()
  private var pushRegistry: PKPushRegistry?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = IsometrikCallFlutterPlugin()
    let channel = FlutterMethodChannel(name: instance.channel, binaryMessenger: registrar.messenger())
  
    registrar.addMethodCallDelegate(instance, channel: channel)
    // Initialize PushKit registry
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

    private func startFlutterEngineIfNeeded(_ call: IncomingCall) {
        if flutterEngine == nil {
            flutterEngine = FlutterEngine(name: "io.flutter", project: nil)
            flutterEngine?.run()
            if let flutterEngine = flutterEngine {
                GeneratedPluginRegistrant.register(with: flutterEngine)
            }
        }

        if let flutterEngine = flutterEngine {
            if let controller = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController {
                let methodChannel = FlutterMethodChannel(name: channel, binaryMessenger: controller.binaryMessenger)
                DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                    methodChannel.invokeMethod("handleIncomingPush", arguments: call.data.toJSON())
                }
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
    
    private func handleIncomingPush(with payload: PKPushPayload) {
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
        
        handleIncomingCalls(call: call)
    }
    
    private func handleIncomingCalls(call: IncomingCall) {
        print("LOG: handleIncomingCalls \(call.id)")
        incomingCalls[call.id] = call
        startRinging(call: call)
    }
    
    private func startRinging(call: IncomingCall) {
        print("LOG: startRinging \(call.id)")
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming(call.data, fromPushKit: true)
        DispatchQueue.main.async {
            self.startFlutterEngineIfNeeded(call)
            self.removeCall(call.id)
        }
    }
    
    private func checkCallQueue() {
        print("LOG: checkCallQueue")
        let now = Date()
        
        for (id, call) in incomingCalls {
            print("LOG: checkCallQueue - \(id)")
            if call.expirationTime <= now {
                removeCall(id)
            } else {
                startRinging(call: call)
                break
            }
        }
    }
    
    private func removeCall(_ id: String) {
        print("LOG: removeCall")
        incomingCalls.removeValue(forKey: id)
    }

    // ------- Method Channel Functions --------
    
    private func handleRinging(_ callId: String) {
        print("LOG: Handling ringing event for: \(callId)")
    }
    
    private func handleCallDeclined(_ callId: String) {
        print("LOG: Handling call declined event for: \(callId)")
        removeCall(callId)
        checkCallQueue()
    }
    
    private func handleCallStarted(_ callId: String) {
        print("LOG: Handling call started/accepted event for: \(callId)")
        ongoingCall = incomingCalls[callId]
    }
    
    private func handleTimeout(_ callId: String) {
        print("LOG: Handling timeout event for: \(callId)")
        removeCall(callId)
        checkCallQueue()
    }
    
    private func handleCallEnd(_ callId: String) {
        print("LOG: Handling call end event for: \(callId)")
        ongoingCall = nil
        checkCallQueue()
    }
}
