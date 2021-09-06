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
//  RESTClient.swift
//  myuplink
//
//  Created by Thomas Kausch on 24.05.21.
//

import Foundation


public enum HttpMethod: String {
    case GET, POST, PUT, DELETE
}

public typealias ResultCompletion<V,E: Error> = (Result<V, E>) -> Void

public class HttpClient {
    
    private let host: String
    private let timeout: TimeInterval
    private let urlSession: URLSession

    
    // used for mocking response selection
    // when multiple http status codes are possible
    public var mockResponseCode: Int?
    
    
    public init(host: String, session: URLSession = URLSession.shared, timeout: TimeInterval = 10.0) {
        self.host = host
        self.urlSession = session
        self.timeout = timeout
    }
    
    var httpHeaders: [String : String]  {
        var httpHeaders = [String:String]()
        httpHeaders["Accept"] = "application/json"
        
        if let response_code = mockResponseCode {
           httpHeaders["x-mock-response-code"] = "\(response_code)"
        }
        
        return httpHeaders
    }
    
    public func executeRequest<T: Request>(request: T, completion: @escaping ResultCompletion<T.Response, Error>) {
        do {
            try send(request: request) { result in
                completion(result)
            }
        } catch {
            completion(Result.failure(error))
        }
    }
    
    private func send<T: Request>(request: T, completion: @escaping ResultCompletion<T.Response, Error>) throws {

        // construct url from endpoint
        let url = try request.endpoint.url(host: host, queryParameters: request.queryParameters)
        
        // construct request and adjust parameters later
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: timeout)

        // Set http method used for the corresponding endpoint.
        urlRequest.httpMethod = request.endpoint.method.rawValue
        
        // Add http header values for request...
        // Note: httpHeaders is a computed property and can be overriden by subclass
        httpHeaders.forEach({ key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        })
        
        // Only a json request body for POST and PUT method. GET, DELETE do not have a body.
        if urlRequest.httpMethod == "POST" || urlRequest.httpMethod == "PUT" {
            do {
                urlRequest.httpBody = try JSONEncoder().encode(request)
            } catch {
                Log.shared.error("Could not marshall request: \(urlRequest)")
                throw RemoteError.marshallingError(error)
            }
        }
        
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse, let httpStatusCode = httpResponse.status else {
                completion(Result.failure(RemoteError.otherError(error)))
                return
            }
            
            if httpStatusCode.type == .success  {
                do {
                    if let responseData = data, responseData.count > 0 {
                        // We got json data response and can decode it now...
                        let responseObj = try JSONDecoder().decode(T.Response.self, from: responseData)
                        completion(Result.success(responseObj))
                    
                    } else {
                        
                        // No response data! Return VoidResponse object
                        let responseObj = try JSONDecoder().decode(T.Response.self, from: "{ }".data(using: .utf8)!  )
                        completion(Result.success(responseObj))
                    }
                } catch {
                    // We can not decode json as it is not valid...
                    Log.shared.error("Could not unmarshall json data! Source error: \(error.localizedDescription)")
                    completion(Result.failure(RemoteError.unmarshallingError(error)))
                }
                
            } else  if httpStatusCode.type == .serverError {
                Log.shared.error("Caught server error with HTTP status code <\(httpStatusCode.rawValue)>.")
                completion(Result.failure(RemoteError.serverError(status: httpStatusCode)))
            } else if httpStatusCode.type == .clientError {
                Log.shared.error("Caught client error with HTTP status code <\(httpStatusCode.rawValue)>.")
                completion(Result.failure(RemoteError.clientError(status: httpStatusCode)))
            } else if let e = error {
                Log.shared.error("Caught other error sending http request! Source error: \(e.localizedDescription)")
                completion(Result.failure(RemoteError.otherError(e)))
            }
            
        }
        task.resume()
        
    }
    
}

