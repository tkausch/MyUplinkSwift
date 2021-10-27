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
//  ApiEndpoints.swift
//  myuplink
//
//  Created by Thomas Kausch on 22.06.21.
//

import Foundation


enum MyUplinkEndpoints: Endpoint {
  
    case aidMode(deviceId: String)
    case categories(systemId: String)
    case deviceInfo(deviceId: String)
    case devicePoints(deviceId: String)
    case firmware(deviceId: String)
    case notifications(systemId: String)
    case notificationsActive(systemId: String)
    case ping
    case premiumSubscriptions(systemId: String)
    case smartHomeMode(systemId: String)
    case systemDetails(systemId: String)
    case systems
    
    
    /// Version number of MyUplink rest API
    var version: String {
        return "v2"
    }
    
    
    var method: HttpMethod {
        switch self {
        case .aidMode(deviceId: _),
             .categories(systemId: _),
             .deviceInfo(deviceId: _),
             .devicePoints(deviceId: _),
             .firmware(deviceId: _),
             .notifications(systemId: _),
             .notificationsActive(systemId: _),
             .ping,
             .premiumSubscriptions(systemId: _),
             .systems,
             .systemDetails(systemId: _),
             .smartHomeMode(systemId: _):
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .aidMode(deviceId:  let deviceId):
            return "/\(version)/devices/\(deviceId)/aidMode"
        case .categories(systemId: let systemId):
            return "/\(version)/systems/\(systemId)/categories"
        case .deviceInfo(deviceId: let deviceId):
            return "/\(version)/devices/\(deviceId)"
        case .devicePoints(deviceId: let deviceId):
            return "/\(version)/devices/\(deviceId)/points"
        case .firmware(deviceId: let deviceId):
            return "/\(version)/devices/\(deviceId)/firmware"
        case .notificationsActive(systemId: let systemId):
            return "/\(version)/systems/\(systemId)/notifications/active"
        case .notifications(systemId: let systemId):
            return "/\(version)/systems/\(systemId)/notifications"
        case .ping:
            return "/\(version)/protected-ping"
        case .premiumSubscriptions(systemId: let systemId):
            return "/\(version)/systems/\(systemId)/subscriptions"
        case .systems:
            return "/\(version)/systems/me"
        case .systemDetails(systemId: let systemId):
            return "/\(version)/systems/\(systemId)"
        case .smartHomeMode(systemId: let systemId):
            return "/\(version)/systems/\(systemId)/smart-home-mode"
        }
    }
    
}
