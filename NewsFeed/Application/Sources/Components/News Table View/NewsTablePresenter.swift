//
//  NewsTablePresenter.swift
//  NewsFeed
//
//  Created by Serhii Palash on 10/11/2018.
//  Copyright © 2018 Serhii Palash. All rights reserved.
//

import UIKit

protocol NewsTablePresenterDelegate: Delegate {
    func newsTablePresenterDidPulledForRefresh(presenter: NewsTablePresenter)
    func newsTablePresenterWillFinishDisplaying(presenter: NewsTablePresenter)
    func newsTablePresenterDidSelectNews(news: News, presenter: NewsTablePresenter)
    func newsTablePresenterDidScroll(presenter: NewsTablePresenter)
}

protocol NewsTablePresenter: Presenter {
    var newsCount: Int { get }
    
    func didPulledForRefresh()
    func willDisplayNewsAt(index: Int)
    func newsFor(index: Int) -> News
    func didSelectNewsAt(index: Int)
    func didScroll()
}

class NewsTablePresenterImpl: NewsTablePresenter {
    
    weak var delegate: NewsTablePresenterDelegate?
    
    unowned private let tableView: NewsTableView
    
    let newsCountDown = 20
    var previousNewsCount = 0
    
    var news: [News] = [] {
        willSet {
            previousNewsCount = news.count
        }
        didSet {
            if previousNewsCount > news.count {
                previousNewsCount = 0
            }
            
            tableView.showNews()
            tableView.hideLazyLoadIndicator()
            tableView.hideRefreshIndicator()
        }
    }
    
    var newsCount: Int {
        return news.count
    }
    
    required init(view: NewsTableView) {
        self.tableView = view
    }
    
    func scrollTableViewToTop() {
        tableView.scrollToTop()
    }
    
    func didPulledForRefresh() {
        tableView.showRefreshIndicator()
        delegate?.newsTablePresenterDidPulledForRefresh(presenter: self)
    }
    
    func willDisplayNewsAt(index: Int) {
        if shouldStartLazyLoading(index: index) {
            tableView.showLazyLoadIndicator()
            delegate?.newsTablePresenterWillFinishDisplaying(presenter: self)
        }
    }
    
    func didSelectNewsAt(index: Int) {
        delegate?.newsTablePresenterDidSelectNews(news: news[index], presenter: self)
        tableView.showNewsAt(index: index)
    }
    
    func newsFor(index: Int) -> News {
        return news[index]
    }
    
    func didScroll() {
        delegate?.newsTablePresenterDidScroll(presenter: self)
    }
    
    func shouldStartLazyLoading(index: Int) -> Bool {
        let isLazyLoadIndex = news.count - index == newsCountDown
        let isLoadingNeeded = previousNewsCount < news.count
        
        return isLazyLoadIndex && isLoadingNeeded
    }
}
