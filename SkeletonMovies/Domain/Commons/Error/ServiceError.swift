//
//  ServiceError.swift
//  SkeletonMovies
//
//  Created by Jesus Calleja Rodriguez on 15/10/23.
//

import Foundation

class ServiceError: Error {
    
    enum ErrorType {
        case generalError
        case urlNil
        case error(error: Error)
        case noInternetcConnection
        case dataNil
        case invalidParams
        case errorParams
        case unauthorized
        case backendCommunicationError
    }
    
    var type: ErrorType
    var text: String
    
    init(type: ErrorType) {
        LogWarn("Error: \(type)")
        self.type = type
        switch type {
        case .generalError:
            self.text = "General error"
        case .urlNil:
            self.text = "Invalid url"
        case .error(let error):
            self.text = error.localizedDescription
        case .dataNil:
            self.text = "We can't recover the data"
        case .invalidParams:
            self.text = "Invalid request params"
        case .errorParams:
            self.text = "Fail request params"
        case .unauthorized:
            self.text = "User unauthorized"
        case .backendCommunicationError:
            self.text = "The resquest was fail"
        case .noInternetcConnection:
            self.text = "You don't have internet connection"
        }
    }
}

