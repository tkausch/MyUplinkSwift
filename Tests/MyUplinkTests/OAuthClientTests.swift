//
//  OAuthClientTests.swift
//  MyUplinkTests
//
//  Created by Thomas Kausch on 19.11.21.
//

import XCTest

@testable import MyUplink

class OAuthClientCredentialsTests: ClientTestCase<OAuthClient> {
    
    let clientId = "5798f539-b297"
    let clientSecret = "FBD5472E3155"
    let redirectUrl = "https://oauth.pstmn.io/v1/callback"
    let scope = "READSYSTEM"
    
    let code = "81730kjerljkretw831"
    let state = "876578929aljdlhljkbaerl85"
    
    
    let token = "eyJhbGciOiJSUzI1NiIsImtpZCI6IkRERDcxNjI3QkI2M"
    let tokenType = "Bearer"
    let tokenExpiresIn = 3600
    let tokenScope = OAuthScope.READSYSTEM.rawValue
         
    override func createClient() -> OAuthClient? {
        let oauthConfig = OAuthClientCredentialConfiguration(clientId: clientId, clientSecret: clientSecret, scope: scope)
        return OAuthClient(config: oauthConfig, host: self.mockHost)
    }
    
    
    fileprivate func assertSuccessfulTokenResult(_ result: Result<OAuthToken, ServiceError>) {
        switch result {
        case .failure(let serviceError):
            XCTFail("Could not get access token: \(serviceError.localizedDescription)")
        case .success(let accessToken):
            XCTAssertEqual(accessToken.expiresIn, self.tokenExpiresIn)
            XCTAssertEqual(accessToken.tokenType, self.tokenType)
            XCTAssertEqual(accessToken.scope, self.tokenScope)
            XCTAssertEqual(accessToken.accessToken, self.token)
        }
    }
    
    func testSuccessfulAccessTokenCall() throws {
        client.mockHttpStatus = .ok
        client.token(completion: { result in
            self.assertSuccessfulTokenResult(result)
            self.terminated.fulfill()
        })
    }
    
    func testFailedAccessTokenCall() throws {
        client.mockHttpStatus = .unauthorized
        client.token(completion: { result in
            self.assertFailedRemoteCall (result, expected: .unauthorized)
        })
    }
}



class OAuthAuthorizationCodeTests: OAuthClientCredentialsTests {
    
    override func createClient() -> OAuthClient? {
        let oauthConfig = OAuthAuthorizationCodeConfiguration(clientId: clientId, clientSecret: clientSecret, scope: scope, redirectUrl: redirectUrl)
        return OAuthClient(config: oauthConfig, host: self.mockHost)
    }
    
    
    override func testSuccessfulAccessTokenCall() throws {
        client.mockHttpStatus = .ok
        client.token(code: code, state: state) { result in
            self.assertSuccessfulTokenResult(result)
            self.terminated.fulfill()
        }
    }
    
    
    override func testFailedAccessTokenCall() throws {
        client.mockHttpStatus = .unauthorized
        client.token(code: code, state: state) { result in
            self.assertFailedRemoteCall (result, expected: .unauthorized)
        }
    }
    
    
    
}




