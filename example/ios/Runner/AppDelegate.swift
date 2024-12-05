import UIKit
import CallKit
import AVFAudio
import PushKit
import Flutter
import flutter_callkit_incoming

@main
@objc class AppDelegate: FlutterAppDelegate, PKPushRegistryDelegate {
    let channelName = "com.isometrik.call"

    var methodChannel: FlutterMethodChannel?

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
        methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: controller.binaryMessenger)
               
        methodChannel?.setMethodCallHandler({
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
            let channel = FlutterMethodChannel(name: channelName, binaryMessenger: controller.binaryMessenger)
            
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

        incomingCalls[call.id] = call

        self.startRinging(call: call, payload: payload)
        
       
    }

     func checkIsLoggedIn(completion: @escaping (Bool)->Void){
        if(methodChannel == nil){
            print("Method channel is nil")
            completion(false)
        }
        methodChannel!.invokeMethod("checkIsUserLoggedIn", arguments: nil) { result in
            if let isLoggedIn = result as? Bool {
                print("User is logged in: \(isLoggedIn)")
                completion(isLoggedIn)
                // Use `isLoggedIn` variable as needed in your app
            } else if let error = result as? FlutterError {
                print("Error checking login status: \(error.message ?? "Unknown error")")
                completion(false)
            } else {
                print("Unexpected result type")
                completion(false)
            }
        }
        
    }
    
    func startRinging(call: IncomingCall, payload: PKPushPayload) {
        print("LOG: startRinging \(call.id)")
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming(call.data, fromPushKit: true)
        startFlutterEngineIfNeeded(payload)
        removeCall(call.id)
        checkIsLoggedIn { result in
            if(!result) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.endCall(call: call)
                    self.invalidateAndReRegister()
                }
            }
        }
        
    }

     func endCall(call: IncomingCall) {
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.endCall(call.data)
        
    }
    
    func checkCallQueue() {
        print("LOG: checkCallQueue")
        let now = Date()
        
        for (id, call) in incomingCalls {
            print("LOG: checkCallQueue - \(id)")
            if call.expirationTime <= now {
                removeCall(id)
            } else {
                self.startRinging(call: call, payload: PKPushPayload())
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



    // Method to invalidate token and re-register
    func invalidateAndReRegister() {
    // Re-register by reinitializing PushKit
        pushRegistry = nil
        pushRegistry = PKPushRegistry(queue: DispatchQueue.main)
        pushRegistry?.delegate = self
        pushRegistry?.desiredPushTypes = [.voIP]
    }
}
