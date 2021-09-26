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
//
//  MyUplinkError.swift
//  MyUplink
//
//  Created by Thomas Kausch on 16.09.21.
//

import Foundation


struct UplinkError: Decodable {
    let httpStatusCode: HTTPStatusCode
    let errorCode: Int
    let timestamp: Date
    let details: [String]
    let data: [String : String]
}

extension RemoteServiceError {
    
    var uplinkError: UplinkError? {
        switch self {
        case .httpError(status: _, errorData: let data):
            if let d = data {
                var decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let uplinkError = try? decoder.decode(UplinkError.self, from: d)
                return uplinkError
            } else {
                return nil
            }
        default:
            return nil
        }
    }
    
}

