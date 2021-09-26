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
//  MyUplinkClientTests.swift
//  myuplink
//
//  Created by Thomas Kausch on 06.09.21.
//

import XCTest


@testable import MyUplink

class MyUplinkClientTests: XCTestCase {
    
    // This is the PostMan Mock URL please adjust for your mock!!!
    let mockHost = "d4d4753c-e3f7-4c2b-aecd-f9b96a227cd4.mock.pstmn.io"

    var myUplinkClient: MyUplinkClient!
    var terminated: XCTestExpectation!
    
    
    override func setUpWithError() throws {
        myUplinkClient = MyUplinkClient(host: mockHost)
        terminated = XCTestExpectation(description: "Remote call must terminate!")
    }
    
    override func tearDownWithError() throws {
        wait(for: [terminated!], timeout: 10.0)
    }
    
    // MARK: XCTAssertions used for testing remote calls

    func assertFailedRemoteCall<V>(_ result: Result<V, ServiceError>, expected: HTTPStatusCode) {
        switch result {
        case .success(value: _ ):
            XCTFail("Expecting error with HTTP status code: \(expected)")
            break
        case .failure(error: let e):
                switch e {
                case .httpError(status: let httpStatusCode, errorData: _):
                    XCTAssertTrue(httpStatusCode == expected,
                        "Expecting error with HTTP status code <\(expected.rawValue)>.  But got HTTP status code <\(httpStatusCode.rawValue)>.")
                default:
                    // got data or other error
                    XCTFail("To remote error: \(e).")
                }
           
        }
        self.terminated.fulfill()
    }

    public func assertSuccessfulRemoteCall<V,E>(_ result: Result<V,E>) {
        switch result {
        case .success(value: _):
            break
        case .failure(error: let e):
            XCTFail("Expecting successful result but got: \(e).")
        }
        self.terminated.fulfill()
    }
    
    
}

// MARK: PingTests

extension MyUplinkClientTests {
    
    func testSuccessfulPing() throws {
        myUplinkClient.mockHttpStatus = .noContent
        myUplinkClient.ping() { result in
            self.assertSuccessfulRemoteCall(result)
        }
    }
    
    func testPingForbidden() throws {
        myUplinkClient.mockHttpStatus = .forbidden
        myUplinkClient.ping() { result in
            self.assertFailedRemoteCall(result, expected: .forbidden)
        }
    }
    
    
    func testPingUnauthorized() throws {
        myUplinkClient.mockHttpStatus = .unauthorized
        myUplinkClient.ping() { result in
            self.assertFailedRemoteCall(result, expected: .unauthorized)
        }
    }
}


// MARK: ME Tests

extension MyUplinkClientTests {
    
    func testMeSuccessful() throws {
        myUplinkClient.mockHttpStatus = .ok
        myUplinkClient.me() { result in
            self.assertSuccessfulRemoteCall(result)
        }
    }
    
    func testMeUnauthorized() throws {
        myUplinkClient.mockHttpStatus = .unauthorized
        myUplinkClient.me() { result in
            self.assertFailedRemoteCall(result, expected: .unauthorized)
        }
    }
    
    func testMeForbidden() throws {
        myUplinkClient.mockHttpStatus = .forbidden
        myUplinkClient.me() { result in
            self.assertFailedRemoteCall(result, expected: .forbidden)
        }
    }

    func testMeInternalServerError() throws {
        myUplinkClient.mockHttpStatus = .internalServerError
        myUplinkClient.me() { result in
            self.assertFailedRemoteCall(result, expected: .internalServerError)
        }
    }
 
    func testMeServiceUavailableServerError() throws {
        myUplinkClient.mockHttpStatus = .serviceUnavailable
        myUplinkClient.me() { result in
            self.assertFailedRemoteCall(result, expected: .serviceUnavailable)
            
            switch result {
            case .failure(let remoteServiceError):
                if let upLinkError = remoteServiceError.uplinkError {
                    XCTAssertNotNil(upLinkError)
                } else {
                    XCTFail("Expecting UpLinkError as data")
                }
            case .success(_):
                XCTFail("expecting error")
            }
        }
    }
    
    
}

