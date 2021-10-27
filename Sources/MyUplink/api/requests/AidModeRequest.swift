//
//  AidModeRequest.swift
//  MyUplink
//
//  Created by Thomas Kausch on 20.10.21.
//

import Foundation


struct AidModeRequest: MyUplinkRequest {
    
    typealias ResponseObject = AidModeResponse
    
    let language: Language
    let deviceId: String
    
    var endpoint: Endpoint {
        return MyUplinkEndpoints.aidMode(deviceId: deviceId)
    }
    
}
