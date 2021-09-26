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

    public init(host: String = "myuplink.com", language: Language = .en) {
        super.init(host: host)
    }
    
    public func ping(language: Language = .en, completion: @escaping ResultCompletion<Nil, ServiceError>) {
        executeRequest(request: PingRequest(language: language), completion: completion)
    }
 
    public func systems(language: Language = .en, completion: @escaping ResultCompletion<SystemsPagedResponse, ServiceError>) {
        executeRequest(request: SystemsRequest(language: language), completion: completion)
    }
    
    public func smartHomeMode(language: Language = .en, systemId: String, completion: @escaping ResultCompletion<SmartHomeModeResponse, ServiceError>) {
        executeRequest(request: SmartHomeModeRequest(systemId: systemId, language: language), completion: completion)
    }
 
    public func notifications(language: Language = .en, systemId: String, completion: @escaping ResultCompletion<AlarmsPagedResponse, ServiceError>) {
        executeRequest(request: NotificationsRequest(systemId: systemId, language: language), completion: completion)
    }
    
    
}
