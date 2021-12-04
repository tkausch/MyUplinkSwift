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

class ClientTestCase<T>: XCTestCase {
    
    // This is the PostMan Mock URL please adjust for your mock!!!
    let mockHost = "8e59a882-4edb-4a6e-b41d-3ac5b1ab5ef9.mock.pstmn.io"

    var client: T!
    var terminated: XCTestExpectation!
        
    func createClient() -> T? {
        return nil
    }
    
    override func setUpWithError() throws {
        client = createClient()
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

    func assertSuccessfulRemoteCall<V,E>(_ result: Result<V,E>) {
        switch result {
        case .success(value: _):
            break
        case .failure(error: let e):
            XCTFail("Expecting successful result but got: \(e).")
        }
        self.terminated.fulfill()
    }
    
    
}




class MyUplinkClientTests: ClientTestCase<MyUplinkClient> {
    
    override func createClient() -> MyUplinkClient? {
       return MyUplinkClient(host: mockHost)
    }
    
    let systemId = "522235b0-4e15-46d5-a968-e28dffde203b"
    let deviceId = "21050035-2021-2-24-20-1-11"
}

// MARK: Ping Tests

extension MyUplinkClientTests {
    
    func testSuccessfulPing() throws {
        client.mockHttpStatus = .noContent
        client.ping() { result in
            self.assertSuccessfulRemoteCall(result)
        }
    }
    
    func testPingForbidden() throws {
        client.mockHttpStatus = .forbidden
        client.ping() { result in
            self.assertFailedRemoteCall(result, expected: .forbidden)
        }
    }
    
    
    func testPingUnauthorized() throws {
        client.mockHttpStatus = .unauthorized
        client.ping() { result in
            self.assertFailedRemoteCall(result, expected: .unauthorized)
        }
    }
}


// MARK: Sytem (ME) Tests

extension MyUplinkClientTests {
    
    func testSystemsSuccessful() throws {
        client.mockHttpStatus = .ok
        client.systems() { result in
            self.assertSuccessfulRemoteCall(result)
        }
    }
    
    func testSystemsUnauthorized() throws {
        client.mockHttpStatus = .unauthorized
        client.systems() { result in
            self.assertFailedRemoteCall(result, expected: .unauthorized)
        }
    }
    
    func testSystemsForbidden() throws {
        client.mockHttpStatus = .forbidden
        client.systems() { result in
            self.assertFailedRemoteCall(result, expected: .forbidden)
        }
    }
    
}



// MARK: Sytem (SmartHomeMode) Tests

extension MyUplinkClientTests {

    func testSmartHomeModeSuccessful() throws {
        client.mockHttpStatus = .ok
        client.smartHomeMode(systemId: systemId) { result in
            self.assertSuccessfulRemoteCall(result)
        }
    }
    
    func testSmartHomeModeUnauthorized() throws {
        client.mockHttpStatus = .unauthorized
        client.smartHomeMode(systemId: systemId) { result in
            self.assertFailedRemoteCall (result, expected: .unauthorized)
        }
    }
    
    func testSmartHomeModeForbidden() throws {
        client.mockHttpStatus = .forbidden
        client.smartHomeMode(systemId: systemId) { result in
            self.assertFailedRemoteCall(result, expected: .forbidden)
        }
    }
    
}

// MARK:  Notifications Tests

extension  MyUplinkClientTests {
    
    func testNotificationsSuccessful() throws {
        client.mockHttpStatus = .ok
        client.notifications(systemId: systemId) { result in
            self.assertSuccessfulRemoteCall(result)
        }
    }
    
    func testActiveNotificationsSuccessful() throws {
        client.mockHttpStatus = .ok
        client.activeNotifications(systemId: systemId) { result in
            self.assertSuccessfulRemoteCall(result)
        }
    }
    
    func testNotificationsForbidden() throws {
        client.mockHttpStatus = .forbidden
        client.notifications(systemId: systemId) { result in
            self.assertFailedRemoteCall(result, expected: .forbidden)
        }
    }
    
    func testNotificationsUnauthorized() throws {
        client.mockHttpStatus = .unauthorized
        client.notifications(systemId: systemId) { result in
            self.assertFailedRemoteCall(result, expected: .unauthorized)
        }
    }
    
}


// MARK:  DeviceInfo Tests

extension  MyUplinkClientTests {
    
    func testDeviceInfoSuccessful() throws {
        client.mockHttpStatus = .ok
        client.deviceInfo(deviceId: deviceId) { result in
            self.assertSuccessfulRemoteCall(result)
        }
    }
    
    func testDeviceInfoForbidden() throws {
        client.mockHttpStatus = .forbidden
        client.deviceInfo(deviceId: deviceId) { result in
            self.assertFailedRemoteCall(result, expected: .forbidden)
        }
    }
    
    func testDeviceInfoUnauthorized() throws {
        client.mockHttpStatus = .unauthorized
        client.deviceInfo(deviceId: deviceId) { result in
            self.assertFailedRemoteCall(result, expected: .unauthorized)
        }
    }
    
}


// MARK:  DeviceInfo Tests


extension MyUplinkClientTests {
    
    func testDevicePoints() throws {
        client.mockHttpStatus = .ok
        client.devicePoints(deviceId: deviceId) { result in
            self.assertSuccessfulRemoteCall(result)
        }
    }
    
}

// MARK:  Premium

extension MyUplinkClientTests {
    
    func testPremiumSubscriptions() throws {
        client.mockHttpStatus = .ok
        client.premium(systemId: systemId) { result in
            self.assertSuccessfulRemoteCall(result)
        }
    }
}
