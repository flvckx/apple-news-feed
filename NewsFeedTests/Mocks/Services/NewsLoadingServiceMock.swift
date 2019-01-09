//
//  NewsLoadingServiceMock.swift
//  NewsFeedTests
//
//  Created by Serhii Palash on 27/11/2018.
//  Copyright © 2018 Serhii Palash. All rights reserved.
//

import Moya
@testable import NewsFeed
import PromiseKit

class NewsLoadingServiceMock: NewsLoadingService {
    
    required init(newsNetworkService: MoyaProvider<NewsNetworkService>, databaseService: DatabaseService) { }
    
    required init() { }
    
    let newsListCall = FunctionCall<UInt, Promise<NewsResponse>>()
    func newsList(page: UInt) -> Promise<NewsResponse> {
        return stubCall(newsListCall, argument: page)
    }
    
    let savedNewsListCall = FunctionNoArgsCall<Promise<[News]>>()
    func savedNewsList() -> Promise<[News]> {
        return stubCall(savedNewsListCall)
    }
}
