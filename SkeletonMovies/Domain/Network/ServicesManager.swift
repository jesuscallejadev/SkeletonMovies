//
//  ServicesManager.swift
//  SkeletonMovies
//
//  Created by Jesus Calleja Rodriguez on 15/10/23.
//

import Foundation
import UIKit

protocol ServicesManagerInput {
    func launchRequest(url: String, method: RequestType, body: [String: Any]?, header: [String: Any]?, queryParams: [String: String]?, requiresRefresh: Bool?) async throws -> Data
}

enum RequestType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class ServicesManager {
    private func createURLRequest(url: String, method: RequestType, body: [String: Any]?, header: [String: Any]?, queryParams: [String: String]?) throws -> URLRequest {
        guard let url = URL(string: url) else {
            throw ServiceError(type: .urlNil)
        }
        
        var request = URLRequest(url: url)
        
        if let queryParams = queryParams {
            let queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
            var components = URLComponents()
            components.scheme = url.scheme
            components.host = url.host
            components.path = url.path
            components.queryItems = queryItems
            request = URLRequest(url: components.url ?? url)
        }
        
        request.httpMethod = method.rawValue
        
        if let header = header {
            if let token = header["token"] {
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            if let basicAuth = header["basic"] {
                request.addValue("Basic \(basicAuth)", forHTTPHeaderField: "Authorization")
            }
        }
        
        if let body = body {
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        }
        
        return request
    }
    
    private func handleResponse(data: Data?, response: URLResponse?) throws -> Data {
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                LogWarn("Status code is nil")
                throw ServiceError(type: .backendCommunicationError)
            }
            
            switch statusCode {
            case 200...299:
                if let data = data {
                    return data
                } else {
                    throw ServiceError(type: .dataNil)
                }
            default:
                LogWarn("Service error response: \(String(describing: response))")
                throw ServiceError(type: .backendCommunicationError)
            }
        }
}

extension ServicesManager: ServicesManagerInput {
    func launchRequest(url: String, method: RequestType, body: [String: Any]?, header: [String: Any]?, queryParams: [String: String]?, requiresRefresh: Bool?) async throws -> Data {
        do {
            let request = try createURLRequest(url: url, method: method, body: body, header: header, queryParams: queryParams)
            
            LogInfo("\n ****** Request ******* \n - Url: \(String(describing: request.url?.absoluteURL)) \n - Type: \(String(describing: request.httpMethod)) \n - Params: \(String(describing: body)) \n - Header: \(String(describing: request.allHTTPHeaderFields)) \n")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            LogInfo(" \n ****** Response ******* \n - Code: \(String(describing: (response as? HTTPURLResponse)?.statusCode)) \n - Url: \(String(describing: request.url?.absoluteURL)) \n - Type: \(String(describing: request.httpMethod))")
            
            return try handleResponse(data: data, response: response)
        } catch {
            if let nsError = error as NSError? {
                if nsError.domain == NSURLErrorDomain {
                    if nsError.code == NSURLErrorNotConnectedToInternet {
                        LogWarn("There is no internet connection")
                        throw ServiceError(type: .noInternetcConnection)
                    } else {
                        LogWarn("Network error: \(error.localizedDescription)")
                    }
                } else {
                    LogWarn("Service error: \(error.localizedDescription)")
                    throw ServiceError(type: .error(error: error))
                }
            }
            throw error
        }
    }
}

