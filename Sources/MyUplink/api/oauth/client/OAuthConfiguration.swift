//
//  OAuthConfiguration.swift
//  MyUplink
//
//  Created by Thomas Kausch on 19.11.21.
//

import Foundation

public enum OAuthScope: String {
    case READSYSTEM, WRITESYSTEM
}


public class OAuthConfiguration {
 
    /// OAuth grant type used to get access token
    let grantType: OAuthGrantType
    
    /// This is the callback url (or redirect url) you will be redirected to, after the app is authorized.
    /// The callback url should match the one you have used during the app registration process.
    /// It is used to extract the state and authorization code.
    let redirectUrl: URL?
    
    /// The endpoint for the authorization server. This endpoint is used to get the authorization code.
    let authorizeUrl: URL?
    
    /// The client ID identifier issued to the client during the application registration process.
    let clientId: String
    
    /// The clientSecret identifier issued to the client during the application registration process.
    let clientSecret: String
    
    /// The scope of the access request, it may have multiple space delemited values.
    let scope: String
    
    
    init(grantType: OAuthGrantType, redirectUrl: URL?, authorizeUrl: URL?, clientId: String, clientSecret: String, scope: String) {
        self.grantType = grantType
        self.redirectUrl = redirectUrl
        self.authorizeUrl = authorizeUrl
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.scope = scope
    }
}


class OAuthClientCredentialConfiguration: OAuthConfiguration {
    init(clientId: String, clientSecret: String, scope: String) {
        super.init(grantType: .clientCredentials, redirectUrl: nil, authorizeUrl: nil, clientId: clientId, clientSecret: clientSecret, scope: scope)
    }
}

class OAuthAuthorizationCodeConfiguration: OAuthConfiguration {
    
    static let AuthorizeUrl = "https://api.myuplink.com/oauth/authorize"
    
    init(clientId: String, clientSecret: String, scope: String, redirectUrl: String) {
        super.init(grantType: .authorizationCode,
                   redirectUrl: URL(string: redirectUrl)!,
                   authorizeUrl: URL(string: Self.AuthorizeUrl)!,
                   clientId: clientId,
                   clientSecret: clientSecret,
                   scope: scope)
    }
}





