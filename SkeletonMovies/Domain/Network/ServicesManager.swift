//
//  ServicesManager.swift
//  SkeletonMovies
//
//  Created by Jesus Calleja Rodriguez on 15/10/23.
//

import Foundation
import UIKit

protocol ServicesManagerInput {
    func launchRequest(url: String, method: RequestType, body: [String: Any]?, header: [String: Any]?,
                       queryParams: [String: String]?, requiresRefresh: Bool?, completion: @escaping (DKManagermentResult<Any>) -> Void)
}

extension ServicesManagerInput {
    func launchRequest(url: String, method: RequestType, body: [String: Any]? = nil, header: [String: Any]? = nil, queryParams: [String: String]? = nil, requiresRefresh: Bool? = nil, completion: @escaping (DKManagermentResult<Any>) -> Void) {
        self.launchRequest(url: url, method: method, body: body, header: header, queryParams: queryParams, requiresRefresh: requiresRefresh, completion: completion)
    }
}

enum RequestType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum DKManagermentResult<T> {
    case success(T)
    case error(error: ServiceError)
}

class ServicesManager {
    
    // MARK: - Private method
    
    private func launchService(url: String, type: RequestType, body: [String: Any]?, header: [String: Any]?, queryParams: [String: String]?, requiresRefresh: Bool?, completion: @escaping (DKManagermentResult<Any>) -> Void) {
        
        guard let url = URL(string: url) else {
            completion(.error(error: ServiceError(type: .urlNil)))
            return
        }
        
        var request = URLRequest(url: url)
        
        if let queryParams = queryParams {
            let queryItems = queryParams.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
            var components = URLComponents()
            components.scheme = url.scheme
            components.host = url.host
            components.path = url.path
            components.queryItems = queryItems
            request = URLRequest(url: components.url ?? url)
        }
        
        request.httpMethod = type.rawValue
        
        if let header = header {
            if let token = header["token"] {
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            if let basicAuth = header["basic"] {
                request.addValue("Basic \(basicAuth)", forHTTPHeaderField: "Authorization")
            }
        }
        
        do {
            if let params = body {
                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            }
            
            LogInfo("\n ****** Request ******* \n - Url: \(String(describing: request.url?.absoluteURL)) \n - Type: \(String(describing: request.httpMethod)) \n - Params: \(String(describing: body)) \n - Header: \(String(describing: request.allHTTPHeaderFields)) \n")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                LogInfo(" \n ****** Response ******* \n - Code: \(String(describing: (response as? HTTPURLResponse)?.statusCode)) \n - Url: \(String(describing: request.url?.absoluteURL)) \n - Type: \(String(describing: request.httpMethod))")
                
                if let error = error {
                    if let nsError = error as NSError? {
                        if nsError.domain == NSURLErrorDomain {
                            if nsError.code == NSURLErrorNotConnectedToInternet {
                                LogWarn("There is no internet connection")
                                completion(.error(error: ServiceError(type: .noInternetcConnection)))
                            } else {
                                LogWarn("Network error: \(error.localizedDescription)")
                            }
                        } else {
                            LogWarn("Service error: \(error.localizedDescription)")
                            completion(.error(error: ServiceError(type: .error(error: error))))
                        }
                    }
                    
                } else {
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                        LogWarn("Status code is nil")
                        completion(.error(error: ServiceError(type: .backendCommunicationError)))
                        return
                    }
                    switch statusCode {
                        
                    case 200...299:
                        guard let data = data else {
                            completion(.error(error: ServiceError(type: .dataNil)))
                            return
                        }
                        completion(.success(data))
                        
                    default:
                        LogWarn("Service error response: \(String(describing: response))")
                        completion(.error(error: ServiceError(type: .backendCommunicationError)))
                    }
                }
            }
            task.resume()
        } catch {
            completion(.error(error: ServiceError(type: .errorParams)))
        }
    }
}

// MARK: - ServicesManagerInput

extension ServicesManager: ServicesManagerInput {
    
    func launchRequest(url: String, method: RequestType, body: [String: Any]? = nil, header: [String: Any]? = nil, queryParams: [String: String]? = nil, requiresRefresh: Bool? = false, completion: @escaping (DKManagermentResult<Any>) -> Void) {
        self.launchService(url: url, type: method, body: body, header: header, queryParams: queryParams, requiresRefresh: requiresRefresh) { result in
            switch result {
            case .success(let data):
                guard let data = data as? Data else {
                    completion(.error(error: ServiceError(type: .dataNil)))
                    return
                }
                completion(.success(data))
            case .error(let error):
                completion(.error(error: error))
            }
        }
    }
}

