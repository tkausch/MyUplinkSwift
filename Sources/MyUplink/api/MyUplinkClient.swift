//
//
//  Copyright (C) 2021 Thomas Kausch.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
//
//  Client.swift
//  myuplink
//
//  Created by Thomas Kausch on 14.05.21.
//

import Foundation

public enum Language: String, Encodable {
    case en, de, sv
}


final public class MyUplinkClient: Client {

    /// The localization language used for API messages
    var language: Language
    
    public init(host: String = "myuplink.com", language: Language = .en) {
        self.language = language
        super.init(host: host)
    }
    
    // MARK:- AidMode
    public func aidMode(deviceId: String, completion: @escaping ResultCompletion<AidModeResponse, ServiceError>) {
        executeRequest(request: AidModeRequest(language: language, deviceId: deviceId), completion: completion)
    }
    
    // MARK:- DeviceInfo
    
    /// Queries device information.
    /// - Parameters:
    
    ///   - deviceId: The device identifier
    ///   - completion: The result completion handler
    public func deviceInfo(deviceId: String, completion: @escaping ResultCompletion<DeviceInfoResponse, ServiceError>) {
        executeRequest(request: DeviceInfoRequest(language: language, deviceId: deviceId), completion: completion)
    }
    
    
    // MARK:- DevicePoints
    
    /// Get data points for device
    /// - Parameters:
    ///   - deviceId: The deviceid
    ///   - completion: The result completion handler
    public func devicePoints(deviceId: String, completion: @escaping ResultCompletion<DevicdePointResponse, ServiceError>) {
        executeRequest(request: DevicePointsRequest( deviceId: deviceId, language: language), completion: completion)
    }
    
    
    // MARK:- Notifications
    
    /// Retrieve all (active, inactive and archived) alarms for specified system.
    /// - Parameters:
    ///   - systemId: The system identifier
    ///   - completion: The result completion handler
    public func notifications(systemId: String, completion: @escaping ResultCompletion<AlarmsPagedResponse, ServiceError>) {
        executeRequest(request: NotificationsRequest(systemId: systemId, language: language), completion: completion)
    }
    
    public func activeNotifications(language: Language = .en, systemId: String, completion: @escaping ResultCompletion<AlarmsPagedResponse, ServiceError>) {
        executeRequest(request: ActiveNotificationsRequest(systemId: systemId, language: language), completion: completion)
    }
    
    
    // MARK:- Ping
    
    /// Send ping request to test API availability with authoirzation header.
    /// - Parameters:
    ///   - completion: The result completion handler
    public func ping(completion: @escaping ResultCompletion<Nil, ServiceError>) {
        executeRequest(request: PingRequest(), completion: completion)
    }
    
    // MARK:- Premium
    
    /// Finds out whether the specified system has any active premium subscriptions.
    /// - Parameters:
    ///   - systemId: The system identifier
    ///   - completion: The result compltion handler
    public func premium(systemId: String, completion: @escaping ResultCompletion<DevicePremiumResponse, ServiceError>) {
        executeRequest(request: DevicePremiumRequest(language: language, systemId: systemId), completion: completion)
    }
 
    // MARK:- Systems
    
    /// Get user systems.
    /// - Parameters:
    ///   - completion: The result completion handler
    public func systems(completion: @escaping ResultCompletion<SystemsPagedResponse, ServiceError>) {
        executeRequest(request: SystemsRequest(language: language), completion: completion)
    }
    
    /// Get current smart home mode of a system.
    /// - Parameters:
    ///   - systemId: The system identifier
    ///   - completion: The result completion handler
    public func smartHomeMode(systemId: String, completion: @escaping ResultCompletion<SmartHomeModeResponse, ServiceError>) {
        executeRequest(request: SmartHomeModeRequest(systemId: systemId, language: language), completion: completion)
    }
    
 
    
   
    
    
}
