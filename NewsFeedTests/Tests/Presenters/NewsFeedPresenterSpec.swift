//
//  NewsFeedPresenterSpec.swift
//  NewsFeedTests
//
//  Created by Serhii Palash on 17/11/2018.
//  Copyright © 2018 Serhii Palash. All rights reserved.
//

@testable import NewsFeed
import Nimble
import PromiseKit
import Quick

class NewsFeedPresenterSpec: QuickSpec {
    
    override func spec() {
        
        var presenter: NewsFeedPresenterImpl!
        var viewMock: NewsFeedViewMock!
        var databaseServiceMock: DatabaseServiceMock!
        var newsLoadingServiceMock: NewsLoadingServiceMock!
        
        beforeEach {
            viewMock = NewsFeedViewMock()
            databaseServiceMock = DatabaseServiceMock()
            newsLoadingServiceMock = NewsLoadingServiceMock()
            
            presenter = NewsFeedPresenterImpl(
                view: viewMock,
                databaseService: databaseServiceMock,
                newsLoadingService: newsLoadingServiceMock
            )
        }
        
        describe("NewsFeedPresenterImpl") {
            context("loading view") {
                var deferred: (promise: Promise<NewsResponse>, resolver: Resolver<NewsResponse>)!
                var deferredNews: (promise: Promise<[News]>, resolver: Resolver<[News]>)!
                var newsResponse: NewsResponse!
                
                beforeEach {
                    deferred = Promise<NewsResponse>.pending()
                    deferredNews = Promise<[News]>.pending()
                    newsLoadingServiceMock.newsListCall.returns(deferred.promise)
                    newsLoadingServiceMock.savedNewsListCall.returns(deferredNews.promise)
                }
                
//                it("fetches news response with articles") {
//                    let jsonDecoder = JSONDecoder()
//                    let jsonData = NewsNetworkService.sampleData
//                    newsResponse = try? jsonDecoder.decode(NewsResponse.self, from: )
//                }
//                
                it("fetches news response with no articles") {
                    newsResponse = NewsResponse()
                    deferred.resolver.fulfill(newsResponse)
                    
                    presenter.didLoad()
                    
                    basicLoadExpectations()
                    expect(viewMock.hideLoadingPageViewCall.called).toEventually(beTrue())
                }
                
                it("rejects response") {
                    let error = NSError(domain: "NewsFeedError", code: -1, userInfo: nil)
                    let networkServiceError = NetworkServiceError.unknownError(error)
                    deferred.resolver.reject(networkServiceError)
                    
                    let newsList = [News(), News()]
                    deferredNews.resolver.fulfill(newsList)
                    
                    presenter.didLoad()
                    
                    basicLoadExpectations()
                    expect(viewMock.hideLoadingPageViewCall.called).toEventually(beTrue())
                    expect(newsLoadingServiceMock.newsListCall.called).toEventually(beTrue())
                }
            }
            
            func basicLoadExpectations() {
                expect(viewMock.showLoadingPageViewCall.called).to(beTrue())
                expect(newsLoadingServiceMock.newsListCall.called).to(beTrue())
            }
        }
    }
}
