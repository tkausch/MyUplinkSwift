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
//  TimestampTests.swift
//  myuplink
//
//  Created by Thomas Kausch on 22.06.21.
//

import XCTest
@testable import MyUplink


class TimestampTests: XCTestCase {

    // myuplink is using second precision iso 8601 timestamps
    let iso8601Formatter = ISO8601DateFormatter([.withInternetDateTime])

    func testIso8601TimestampFromDate() throws {
        let now = Date()
        XCTAssertNotNil(now.iso8601Timestamp)
        XCTAssertEqual(now.iso8601Timestamp, iso8601Formatter.string(from: now))
    }
    
    func testDifferentIso8601TimestampFromDate() throws {
        let now = Date()
        let later = now.advanced(by: 1000)
        
        XCTAssertNotNil(now.iso8601Timestamp)
        XCTAssertNotEqual(now.iso8601Timestamp, later.iso8601Timestamp)
    }
    
    func testIso8601TimestampFromString() throws {
        let timestamp = "2021-06-22T19:10:36Z"
        XCTAssertNotNil(timestamp.iso8601Timestamp)
        XCTAssertEqual(timestamp.iso8601Timestamp, iso8601Formatter.date(from: timestamp))
    }
   
    func testDifferentIso8601TimestampFromString() throws {
        let timestamp = "2021-06-22T19:10:36Z"
        let differentTimestamp = "2021-06-22T19:10:37Z"
        XCTAssertNotNil(timestamp.iso8601Timestamp)
        XCTAssertNotEqual(timestamp.iso8601Timestamp, iso8601Formatter.date(from: differentTimestamp))
    }
    
    func testWrongIso8601TimestampFromString() throws {
        XCTAssertNil("2021-06-22T19:10:36.345Z".iso8601Timestamp)
        XCTAssertNil("2021-06-22T19:10Z".iso8601Timestamp)
        XCTAssertNil("2021-06-22T19:10:36".iso8601Timestamp)
    }
}
