//
//  NetworkService.swift
//  NewsFeed
//
//  Created by Serhii Palash on 11/11/2018.
//  Copyright © 2018 Serhii Palash. All rights reserved.
//

import Moya
import PromiseKit

enum NetworkServiceError: Error {
    case invalidResponse(Error)
    case unwrapFailed(String)
    case unknownError(Error)
    case noInternetConnection(error: String, message: String)
}

protocol NewsLoadingService: Service {
    init(newsNetworkService: MoyaProvider<NewsNetworkService>,
         databaseService: DatabaseService
    )
    
    func newsList(page: UInt) -> Promise<NewsResponse>
    func savedNewsList() -> Promise<[News]>
}

class NewsLoadingServiceImpl: NewsLoadingService {
    
    private let newsNetworkService: MoyaProvider<NewsNetworkService>
    private let databaseService: DatabaseService
    
    required init(newsNetworkService: MoyaProvider<NewsNetworkService> = resolve(),
                  databaseService: DatabaseService = resolve()) {
        self.newsNetworkService = newsNetworkService
        self.databaseService = databaseService
    }
    
    func newsList(page: UInt) -> Promise<NewsResponse> {
        return newsNetworkService
            .request(.getNewsList(page: page))
            .then { $0.decodeData() }
    }
    
    func savedNewsList() -> Promise<[News]> {
        return databaseService.load()
    }
}

