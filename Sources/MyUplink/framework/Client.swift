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

public typealias ResultCompletion<V, E: Error> = (Result<V, E>) -> Void

public class Client {
    
    private let host: String
    private let timeout: TimeInterval
    private let urlSession: URLSession

    
    // used for mocking with postman selecting postman example
    var mockHttpStatus: HTTPStatusCode?
    
    
    public init(host: String, session: URLSession = URLSession.shared, timeout: TimeInterval = 10.0) {
        self.host = host
        self.urlSession = session
        self.timeout = timeout
    }
    
    public func executeRequest<T: Request>(request: T, completion: @escaping ResultCompletion<T.ResponseObject, ServiceError>) {
        send(request: request) { result in
                completion(result)
        }
    }
    
    private func dispatchMainAsync(completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            completion()
        }
    }
    
    
    private func send<T: Request>(request: T, completion: @escaping ResultCompletion<T.ResponseObject, ServiceError>)  {

        // construct url from endpoint
        guard let url = request.endpoint.url(host: host, queryParameters: request.queryParameters) else {
            let msg = "Error building url! host=<\(host)>, endpoint=<\(request.endpoint)>, queryParams=<\(String(describing: request.queryParameters))>"
            let remoteError = ServiceError.otherError(msg:"Could not create URL: \(msg)")
            dispatchMainAsync {
                completion(.failure(remoteError))
            }
            return
        }
            
        // construct request and adjust parameters later
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: timeout)

        // Set http method used for the corresponding endpoint.
        urlRequest.httpMethod = request.endpoint.method.rawValue
        
        // Add http header values for request...
        // Note: httpHeaders is a computed property and can be overriden by subclass
        request.httpHeaders.forEach({ key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        })
        
        if let httpStatusCode = mockHttpStatus {
            urlRequest.setValue("\(httpStatusCode.rawValue)", forHTTPHeaderField: "x-mock-response-code")
        }
        
        // Only a json request body for POST and PUT method. GET, DELETE do not have a body.
//        if urlRequest.httpMethod == "POST" || urlRequest.httpMethod == "PUT" {
//            do {
//                urlRequest.httpBody = try JSONEncoder().encode(request.requestObject)
//            } catch {
//                Log.shared.error("Could not marshall request: \(urlRequest)")
//                dispatchMainAsync {
//                    completion(.failure(ServiceError.dataFormatError(error)))
//                }
//            }
//        }
        
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            
            guard error == nil else {
                if let e = error {
                    Log.shared.error("Caught error sending http request!")
                    print(e)
                    self.dispatchMainAsync {
                        completion(Result.failure(ServiceError.otherError(msg: e.localizedDescription)))
                    }
                }
                return
            }
            
            
            guard let httpResponse = response as? HTTPURLResponse, let httpStatusCode = httpResponse.status else {
                if let e = error {
                    print(e)
                    self.dispatchMainAsync {
                        completion(Result.failure(ServiceError.otherError(msg: e.localizedDescription)))
                    }
                } else {
                    self.dispatchMainAsync {
                        completion(Result.failure(ServiceError.otherError(msg: "Did not get response or HTTP status.")))
                    }
                }
                return
            }
            
            if  httpStatusCode.type == .success  {
                do {
                    if let responseData = data, responseData.count > 0 {
                        // We got json data response and can decode it now...
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        let responseObj = try decoder.decode(T.ResponseObject.self, from: responseData)
                        self.dispatchMainAsync {
                            completion(Result.success(responseObj))
                        }
                    } else {
                        
                        // No response data! Return VoidResponse object
                        let responseObj = try JSONDecoder().decode(T.ResponseObject.self, from: "{ }".data(using: .utf8)!  )
                        self.dispatchMainAsync {
                            completion(Result.success(responseObj))
                        }
                    }
                } catch {
                    // We can not decode json as it is not valid...
                    Log.shared.error("Could not unmarshall json data: ")
                    print(error)
                    self.dispatchMainAsync {
                        completion(Result.failure(ServiceError.dataFormatError(error)))
                    }
                }
                
            } else {
                Log.shared.error("HTTP status code <\(httpStatusCode.rawValue)>.")
                self.dispatchMainAsync {
                    completion(Result.failure(ServiceError.httpError(status: httpStatusCode, errorData: data)))
                }
            }
            
        }
        task.resume()
        
    }
    
}

