//
//  NewNetworkService.swift
//  NewsFeed
//
//  Created by Serhii Palash on 11/11/2018.
//  Copyright © 2018 Serhii Palash. All rights reserved.
//

import Moya


enum NewsNetworkService {
    case getNewsList(page: UInt)
}

extension NewsNetworkService: TargetType, LegacyEndPoint, AuthorizedRequest {
    
    var path: String {
        switch self {
        case .getNewsList:
            return "/v2/everything"
        }
    }
    
    var method: Method {
        switch self {
        case .getNewsList:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getNewsList(let page):
            let parameters:  [String : Any] = [
                "q": "apple",
                "page": page,
                "apiKey": apiKey
                ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
        
    var sampleData: Data {
        switch self {
        case .getNewsList:
            return """
                {
                status": "ok",
                "totalResults": 1338,
                "articles": [
                    {
                    "source": {
                              "id": "engadget",
                              "name": "Engadget"
                              },
                    "author": "Richard Lawler",
                    "title": "Apple announces repair programs for iPhone X, MacBook Pro problems",
                    "description": "As it tends to do, Apple has chosen a Friday evening to announce programs that will replace flawed components on a couple of its devices. First up is a display module replacement program for the iPhone X. Some owners have been reporting touch issues since the…",
                    "url": "https://www.engadget.com/2018/11/09/iphone-x-macbook-pro-13-ssd-apple/",
                    "urlToImage": "https://o.aolcdn.com/images/dims?thumbnail=1200%2C630&quality=80&image_uri=https%3A%2F%2Fo.aolcdn.com%2Fimages%2Fdims%3Fresize%3D2000%252C2000%252Cshrink%26image_uri%3Dhttps%253A%252F%252Fs.yimg.com%252Fos%252Fcreatr-uploaded-images%252F2018-11%252F36a5b460-e486-11e8-af7f-1acdb9bd7815%26client%3Da1acac3e1b3290917d92%26signature%3D142e4768c9f4251872eb64837df52e7c3b954e7f&client=amp-blogside-v2&signature=138a31fdfb475911e09abe769597517abe466ec0",
                    "publishedAt": "2018-11-10T01:29:00Z",
                    "content": "The other issue identified today focuses on SSD-equipped 13-inch MacBook Pro laptops without a touchbar sold between June 2017 and June 2018. Specific units with 128GB or 256GB SSDs have a problem that could cause data loss and failure, so Apple says it will … [+671 chars]"
                    },
                }
                """.utf8Encoded
        }
    }
}
