//
//  IncomingCallModel.swift
//  Runner
//
//  Created by 3embed on 06/08/24.
//

import Foundation
import flutter_callkit_incoming

public class IncomingCall {
    let id: String
    let data: flutter_callkit_incoming.Data
    let expirationTime: Date
    
    public init(id: String, data: flutter_callkit_incoming.Data, expirationTime: Date) {
        self.id = id
        self.data = data
        self.expirationTime = expirationTime
    }
    
    public func toJSON() -> [String: Any] {
        return [
            "id": id,
            "data": data.extra,
            "expirationTime": expirationTime,
        ]
    }
}
