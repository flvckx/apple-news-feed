//
//  NewsFeedViewMock.swift
//  NewsFeedTests
//
//  Created by Serhii Palash on 26/11/2018.
//  Copyright © 2018 Serhii Palash. All rights reserved.
//

@testable import NewsFeed

class NewsFeedViewMock: NewsFeedView {
    
    let showNewsTableViewCall = FunctionVoidNoArgsCall()
    func showNewsTableView() {
        stubCall(showNewsTableViewCall)
    }
    
    let hideNewsTableViewMock = FunctionVoidNoArgsCall()
    func hideNewsTableView() {
        stubCall(hideNewsTableViewMock)
    }
    
    let openNewsDetailsCall = FunctionVoidCall<News>()
    func openNewsDetails(news: News) {
        stubCall(openNewsDetailsCall, argument: news)
    }
    
    let showLoadingPageViewCall = FunctionVoidNoArgsCall()
    func showLoadingPageView() {
        stubCall(showLoadingPageViewCall)
    }
    
    let hideLoadingPageViewCall = FunctionVoidNoArgsCall()
    func hideLoadingPageView() {
        stubCall(hideLoadingPageViewCall)
    }
}
