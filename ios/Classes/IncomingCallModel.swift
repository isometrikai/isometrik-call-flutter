//
//  IncomingCallModel.swift
//  isometrik_call_flutter
//
//  Created by Rajkumar Gahane
//

import Foundation
import flutter_callkit_incoming

public class IncomingCall {
    public let id: String
    public let data: flutter_callkit_incoming.Data
    public let expirationTime: Date
    
    public init(id: String, data: flutter_callkit_incoming.Data, expirationTime: Date) {
        self.id = id
        self.data = data
        self.expirationTime = expirationTime
    }
    
    public func toJSON() -> [String: Any] {
        return [
            "id": id,
            "data": data.extra ?? [:],
            "expirationTime": expirationTime.timeIntervalSince1970,
        ]
    }
}
