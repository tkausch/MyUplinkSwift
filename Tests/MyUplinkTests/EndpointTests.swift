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
//  EndpointTests.swift
//  myuplink
//
//  Created by Thomas Kausch on 22.06.21.
//

import XCTest

@testable import MyUplink

enum DummyEndpoint: Endpoint {
    
    case a(identifier: String)
    
    var method: HttpMethod  {
        return .GET
    }
    
    var path: String {
        switch self {
        case .a(identifier: let identifier):
            return "/a/\(identifier)"
        }
    }
}



class EndpointTests: XCTestCase {

    // Creates the endpoint '/a/1'
    let endpoint = DummyEndpoint.a(identifier: "1")
    
    let host = "myuplink.com"
    
    let param1 = "param1"
    
    let value1 = "q87348095234"
    let value3 = ".$$870345"
    let value4 = "=?"
    
    func testPath() throws {
        XCTAssertEqual(endpoint.path, "/a/1")
    }

    func testMethod() throws {
        XCTAssertEqual(endpoint.method, .GET)
    }

    func testUrl() throws {
        
        let queryParams = [param1: value1]
        let url: URL? = endpoint.url(host: host, queryParameters: queryParams)
        
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.host, host)
        XCTAssertEqual(url?.scheme, "https")
        XCTAssertEqual(url?.query, "\(param1)=\(value1)")
    }
    
    func testUrlQueryParamEncoding() throws {
        let queryParams = [param1: value3]
        let url = endpoint.url(host: host, queryParameters: queryParams)
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.query, "\(param1)=\(value3.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")
    }

}
