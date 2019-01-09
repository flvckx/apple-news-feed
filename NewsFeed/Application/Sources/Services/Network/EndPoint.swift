//
//  EndPoint.swift
//  NewsFeed
//
//  Created by Serhii Palash on 11/11/2018.
//  Copyright © 2018 Serhii Palash. All rights reserved.
//

import Foundation

fileprivate let baseURLKey = "BASE_URL"
fileprivate let newsAPIKey = "NEWS_API_KEY"

protocol EndPoint {
    
    var baseURL: URL { get }
}

var authToken = ""

protocol LegacyEndPoint: EndPoint { }

extension LegacyEndPoint {
    
    var apiKey: String {
        return Bundle.main.object(forInfoDictionaryKey: newsAPIKey) as? String ?? ""
    }
    
    var baseURL: URL {
        guard let stringURL = Bundle.main.object(forInfoDictionaryKey: baseURLKey) as? String,
            let url = URL(string: stringURL) else {
                fatalError("Unable to parse base URL from info dictionary string representation.")
        }
        
        return url
    }
}

protocol AuthorizedRequest {
    var headers: [String: String]? { get }
}

extension AuthorizedRequest {
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
