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
//  OAuthEndpoints.swift
//  MyUplink
//
//  Created by Thomas Kausch on 19.11.21.
//

import Foundation


enum OAuthEndpoints: Endpoint {
  
    /// Identity OAuth
    case oauthToken
    
    /// Version number of MyUplink rest API
    var version: String {
        return "v2"
    }
    
    
    var method: HttpMethod {
        switch self {
        case .oauthToken:
            return .POST
        }
    }
    
    var path: String {
        switch self {
        case .oauthToken:
            return "/oauth/token"
        }
    }
    
}
