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

    var client: MyUplinkClient!
    var allRemoteCallsTerminated: XCTestExpectation!
    
    
    override func setUpWithError() throws {
        client = MyUplinkClient(host: mockHost)
        allRemoteCallsTerminated = XCTestExpectation(description: "Remote calls should have terminated!")
    }
    
    override func tearDownWithError() throws {
        wait(for: [allRemoteCallsTerminated!], timeout: 10.0)
    }
    
    private func callPing(expectedHttpStatusCode: Int) {
        client.mockResponseCode = expectedHttpStatusCode
        client.ping(completion: { result in
            switch result {
            case .success(VoidResponse: _):
                XCTFail("Ping should not succeed")
            case .failure(Error: let e):
                if let remoteError = e as? RemoteError {
                    switch remoteError {
                    case .clientError(status: let s):
                        XCTAssertTrue(s.rawValue == expectedHttpStatusCode, "We expect ping to return error status <\(expectedHttpStatusCode)>")
                    default:
                        break
                    }
                } else {
                    XCTFail("RemoteError expected but got: \(e)")
                }
            }
            self.allRemoteCallsTerminated?.fulfill()
        })
    }
    
    
    func testPing204() throws {
        client.mockResponseCode = 204
        client.ping(completion: { result in
            switch result {
            case .failure(Error: _):
                XCTFail("Ping should succeed.")
            default:
                break
            }
            self.allRemoteCallsTerminated?.fulfill()
        })
        
    }

    
    func testPing401() throws {
        callPing(expectedHttpStatusCode:401)
    }

    func testPing403() throws {
        callPing(expectedHttpStatusCode:403)
    }
    
    
    
}
