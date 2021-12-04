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
        XCTAssertNotNil(now.iso8601)
        XCTAssertEqual(now.iso8601, iso8601Formatter.string(from: now))
    }
    
    func testDifferentIso8601TimestampFromDate() throws {
        let now = Date()
        let later = now.advanced(by: 1000)
        
        XCTAssertNotNil(now.iso8601)
        XCTAssertNotEqual(now.iso8601, later.iso8601)
    }
    
    func testIso8601FromString() throws {
        let input = "2021-06-22T19:10:36Z"
        XCTAssertNotNil(input.iso8601)
        XCTAssertEqual(input.iso8601, iso8601Formatter.date(from: input))
    }
   
    func testDifferentIso8601FromString() throws {
        let inputA = "2021-06-22T19:10:36Z"
        let inputB = "2021-06-22T19:10:37Z"
        XCTAssertNotNil(inputA.iso8601)
        XCTAssertNotEqual(inputA.iso8601, iso8601Formatter.date(from: inputB))
    }
    
    func testIso8601WithFractionsTimestampFromString() throws {
        let input = "2021-06-22T19:10:36.123Z"
        XCTAssertNotNil(input.iso8601WithFractionalSeconds)
    }
    
    
    func testWrongIso8601FromString() throws {
        XCTAssertNil("2021-06-22T19:10Z".iso8601)
        XCTAssertNil("2021-06-22T19:10:36".iso8601)
        XCTAssertNil("2021-06-22T19:10:36.123Z".iso8601)
    }
}
