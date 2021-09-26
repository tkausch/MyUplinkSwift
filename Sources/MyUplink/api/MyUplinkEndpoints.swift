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
  
    case ping
    case me
    case smartHomeMode(systemId: String)
    case systemDetails(systemId: String)
    case notifications(systemId: String)
    case categories(systemId: String)
    case deviceInfo(deviceId: String)
    case dataPoints(deviceId: String)
    case firmware(deviceId: String)
    
    
    /// Version number of MyUplink rest API
    var version: String {
        return "v2"
    }
    
    
    var method: HttpMethod {
        switch self {
        case .ping,
             .me,
             .smartHomeMode(systemId: _),
             .systemDetails(systemId: _),
             .notifications(systemId: _),
             .categories(systemId: _),
             .deviceInfo(deviceId: _),
             .dataPoints(deviceId: _),
             .firmware(deviceId: _):
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .ping:
            return "/\(version)/protected-ping"
        case .me:
            return "/\(version)/systems/me"
        case .smartHomeMode(systemId: let systemId):
            return "/\(version)/systems/\(systemId)/smart-home-mode"
        case .systemDetails(systemId: let systemId):
            return "/\(version)/systems/\(systemId)"
        case .categories(systemId: let systemId):
            return "/\(version)/systems/\(systemId)/categories"
        case .notifications(systemId: let systemId):
            return "/\(version)/systems/\(systemId)/notifications"
        case .deviceInfo(deviceId: let deviceId):
            return "/\(version)/devices/\(deviceId)"
        case .dataPoints(deviceId: let deviceId):
            return "/\(version)/devices/\(deviceId)/points"
        case .firmware(deviceId: let deviceId):
            return "/\(version)/devices/\(deviceId)/firmware"
        }
    }
    
}
