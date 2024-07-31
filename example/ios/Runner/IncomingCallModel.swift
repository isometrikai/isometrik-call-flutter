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
