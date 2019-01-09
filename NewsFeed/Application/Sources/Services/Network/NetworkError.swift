//
//  NetworkError.swift
//  NewsFeed
//
//  Created by Serhii Palash on 11/11/2018.
//  Copyright © 2018 Serhii Palash. All rights reserved.
//

import Moya

struct NetworkError: Error, LocalizedError, Decodable {
    
    let code: Int?
    let debug: String?
    let error: String?
    private(set) var errorDescription: String?
    let message: String?
    let name: String?
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case code
        case debug
        case error
        case errorDescription = "error_description"
        case message
        case name
        case status
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        debug = try values.decodeIfPresent(String.self, forKey: .debug)
        error = try values.decodeIfPresent(String.self, forKey: .error)
        
        message = try values.decodeIfPresent(String.self, forKey: .message)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        errorDescription = try values.decodeIfPresent(String.self, forKey: .errorDescription) ?? debug
    }
}

extension NetworkError {
    
    init?(moyaError: Error) {
        guard let moyaError = moyaError as? MoyaError,
            let data = moyaError.response?.data,
            let error = try? JSONDecoder().decode(NetworkError.self, from: data) else {
                return nil
        }
        self = error
    }
}
