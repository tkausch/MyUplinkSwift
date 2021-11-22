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
//  TokenRequest.swift
//  MyUplink
//
//  Created by Thomas Kausch on 19.11.21.
//

import Foundation



struct OAuthTokenRequest: MyUplinkRequest {
    
    typealias ResponseObject = OAuthToken
    
    let language: Language = .en
    
    var requestObject: OAuthTokenParameter
    
    var endpoint: Endpoint {
        return MyUplinkEndpoints.oauthToken
    }
    
    init(grantType: OAuthGrantType, clientId: String, clientSecret: String, code: String?, redirectUrl: URL?) {
        self.requestObject = OAuthTokenParameter(grantType: grantType,
                                                 code: code,
                                                 redirectUri: redirectUrl?.absoluteString,
                                                 clientId: clientId,
                                                 clientSecret: clientSecret)
    }
    
}
