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
//  OAuthClient.swift
//  MyUplink
//
//  Created by Thomas Kausch on 19.11.21.
//

import Foundation




final public class OAuthClient: Client {
    
    let config: OAuthConfiguration
    
    public init(config: OAuthConfiguration, host: String) {
        self.config = config
        super.init(host: host)
    }
    
    // MARK:- Authorization code flow methods
    
    private static func createAuthorizeCodeWithPkceURL(authorizeUrl: URL, clientId: String, scope: String, redirectUri: String, codeChallenge: String) -> URL? {
        
        guard  var authorizeUrlComponents = URLComponents(string: authorizeUrl.absoluteString) else {
            return nil
        }
    
        // parse/insert parameters
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "ReturnUrl", value: "/connect/authorize/callback"))
        queryItems.append(URLQueryItem(name: "response_type", value: "code"))
        queryItems.append(URLQueryItem(name: "client_id", value: clientId))
        queryItems.append(URLQueryItem(name: "scope", value: scope))
        queryItems.append(URLQueryItem(name: "redirect_uri", value: redirectUri))
        queryItems.append(URLQueryItem(name: "code_challenge", value: codeChallenge))
        queryItems.append(URLQueryItem(name: "code_challenge_method", value: "S256"))
        
        authorizeUrlComponents.queryItems = queryItems
        
        return authorizeUrlComponents.url
    }
    
    
    public func startAuthorize() {
        
        
        
    }
    
    
    
    public func token(code: String, state: String, completion: @escaping ResultCompletion<OAuthToken, ServiceError>) {
     
        let oauthTokenRequest = OAuthTokenRequest(grantType: .authorizationCode,
                                                  clientId: config.clientId,
                                                  clientSecret: config.clientSecret,
                                                  code: code,
                                                  redirectUrl: config.redirectUrl)
        
        executeRequest(request: oauthTokenRequest, completion: completion)
    }
    
    
    // MARK:- ClientCredentail flow method
    
    public func token(completion: @escaping ResultCompletion<OAuthToken, ServiceError>) {
     
        guard self.config.grantType == .clientCredentials else {
            assertionFailure("Invalid OAuthConfig (expecting client credential flow)for this operation")
            return
        }
        
        let oauthTokenRequest = OAuthTokenRequest(grantType: .clientCredentials,
                                                  clientId: config.clientId,
                                                  clientSecret: config.clientSecret,
                                                  code: nil,
                                                  redirectUrl: config.redirectUrl) // is nil
        
        executeRequest(request: oauthTokenRequest, completion: completion)
    }
    
    
}
