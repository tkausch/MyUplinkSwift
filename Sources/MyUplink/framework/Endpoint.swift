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
//  Endpoint.swift
//  myuplink
//
//  Created by Thomas Kausch on 14.05.21.
//

import Foundation

/// Protocol for Rest API endpoints
public protocol Endpoint {
    var method: HttpMethod { get }
    var path: String { get }
}


extension Endpoint {
    
    func url(host: String, queryParameters: [String : String]?) throws -> URL  {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        
        // add query parameters to url
        if let queryParams = queryParameters {
            components.queryItems = queryParams.compactMap({ (key: String, value: String) in
                let queryItem = URLQueryItem(name: key, value: value)
                return queryItem.value != nil ? queryItem : nil
            })
        }
        
        guard let url = components.url else {
            Log.shared.error("Error building url! host=<\(host)>, path=<\(path)>, queryParams=<\(String(describing: queryParameters))>")
            throw RemoteError.urlComponentError(reason: "Could not buld URL from \(components)!")
        }
        
        return url
    }
    
}
