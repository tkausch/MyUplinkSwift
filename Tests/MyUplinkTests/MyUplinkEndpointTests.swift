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
//  ApiEndpointTests.swift
//  myuplink
//
//  Created by Thomas Kausch on 22.06.21.
//

import XCTest

@testable import MyUplink


class MyUplinkEndpointTests: XCTestCase {

    let version = "v2"


//case .firmware(deviceId: let deviceId):
//    return
//
    func testProtectedPingEndpoint() throws {
        let ping = MyUplinkEndpoints.ping
        XCTAssertEqual(ping.path, "/\(version)/protected-ping")
        XCTAssertEqual(ping.method, .GET)
    }
    
    func testAllSystemsEndpoint() throws {
        let allSystems = MyUplinkEndpoints.systems
        XCTAssertEqual(allSystems.path, "/\(version)/systems/me")
        XCTAssertEqual(allSystems.method, .GET)
    }

    func testSystemDetailsEndpoint() throws {
        let systemId = "522235b0-4e15-46d5-a968-e28dffde203b"
        let systemDetails = MyUplinkEndpoints.systemDetails(systemId: systemId)
        XCTAssertEqual(systemDetails.path, "/\(version)/systems/\(systemId)")
        XCTAssertEqual(systemDetails.method, .GET)
    }
    
    func testCategoriesEndpoint() throws {
        let systemId = "522235b0-4e15-46d5-a968-e28dffde203b"
        let categories = MyUplinkEndpoints.categories(systemId: systemId)
        XCTAssertEqual(categories.path, "/\(version)/systems/\(systemId)/categories")
        XCTAssertEqual(categories.method, .GET)
    }
    
    func testDeviceInfoEndpoint() throws {
        let deviceId = "21050035-2021-2-24-20-1-11"
        let deviceInfo = MyUplinkEndpoints.deviceInfo(deviceId: deviceId)
        XCTAssertEqual(deviceInfo.path, "/\(version)/devices/\(deviceId)")
        XCTAssertEqual(deviceInfo.method, .GET)
    }
 
    func testDatapointEndpont() throws {
        let deviceId = "21050035-2021-2-24-20-1-11"
        let dataPoints = MyUplinkEndpoints.devicePoints(deviceId: deviceId)
        XCTAssertEqual(dataPoints.path,  "/\(version)/devices/\(deviceId)/points")
        XCTAssertEqual(dataPoints.method, .GET)
    }
    
    func testFirmwareEndpoint() throws {
        let deviceId = "21050035-2021-2-24-20-1-11"
        let firmware = MyUplinkEndpoints.firmware(deviceId: deviceId)
        XCTAssertEqual(firmware.path, "/\(version)/devices/\(deviceId)/firmware")
        XCTAssertEqual(firmware.method, .GET)
    }
    
}
