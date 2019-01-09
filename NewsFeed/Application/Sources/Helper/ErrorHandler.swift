//
//  ErrorHandler.swift
//  NewsFeed
//
//  Created by Serhii Palash on 11/11/2018.
//  Copyright © 2018 Serhii Palash. All rights reserved.
//

import Alamofire

class ErrorHandler {
    
    enum DatabaseError {
        case databaseInit, databaseWrite
    }
    
    // MARK: General functions
    func handleError(error: Error?) {
        if let error = error as? AFError {
            handleAFError(error: error)
        } else if let error = error as? URLError {
            print("URLError occurred: \(error)")
        } else {
            print("Unknown error: \(error as Error?)")
        }
    }
    
    func handleDatabaseServiceError(_ error: Error, of kind: DatabaseError) {
        switch kind {
        case .databaseInit:
            print("Database initialization error: \(error)")
        case .databaseWrite:
            print("Database writing error: \(error)")
        }
    }
    
    func handleAFError(error: AFError) {
        switch error {
        case .invalidURL(let url):
            print("Invalid URL: \(url) - \(error.localizedDescription)")
        case .parameterEncodingFailed(let reason):
            print("Parameter encoding failed: \(error.localizedDescription)")
            print("Failure Reason: \(reason)")
        case .multipartEncodingFailed(let reason):
            print("Multipart encoding failed: \(error.localizedDescription)")
            print("Failure Reason: \(reason)")
        case .responseValidationFailed(let reason):
            print("Response validation failed: \(error.localizedDescription)")
            print("Failure Reason: \(reason)")
            handleValidationReason(reason: reason)
        case .responseSerializationFailed(let reason):
            print("Response serialization failed: \(error.localizedDescription)")
            print("Failure Reason: \(reason)")
        }
        print("Underlying error: \(error.underlyingError as Error?)")
    }
    
    func handleValidationReason(reason: AFError.ResponseValidationFailureReason) {
        switch reason {
            
        case .dataFileNil, .dataFileReadFailed:
            print("Downloaded file could not be read")
        case .missingContentType(let acceptableContentTypes):
            print("Content Type Missing: \(acceptableContentTypes)")
        case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
            print("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
        case .unacceptableStatusCode(let code):
            print("Response status code was unacceptable: \(code)")
        }
    }
    
    // MARK: Static functions
    static func errorByCode(_ code: Int, message: String?) -> NSError {
        var errorMessage = message ?? String()
        
        if errorMessage.isEmpty {
            errorMessage = "Something went wrong.\nPlease try again."
        }
        
        switch code {
        case NSURLErrorNotConnectedToInternet:
            errorMessage = "The Internet connection appears to be offline. Please connect your device and try again."
        case NSURLErrorCancelled:
            errorMessage = "The Internet connection appears to be offline. Please connect your device and try again."
        case 401:
            errorMessage = "Please login or register if you do not have account."
        case NSURLErrorTimedOut:
            errorMessage = "You now in offline mode."
        default:
            errorMessage = "Internal error occurred with the request.\nPlease contact MEDIX Team."
        }
        
        return NSError(domain: "NetworkErrorDomain", code: code, userInfo: [NSLocalizedDescriptionKey: errorMessage])
    }
}

