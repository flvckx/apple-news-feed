//
//  NewsFeedPresenter.swift
//  NewsFeed
//
//  Created by Serhii Palash on 10/11/2018.
//  Copyright © 2018 Serhii Palash. All rights reserved.
//

import Foundation
import PromiseKit

protocol NewsFeedPresenter: Presenter {
    var newsTablePresenter: NewsTablePresenterImpl! { get set }
    
    init(view: NewsFeedView,
         databaseService: DatabaseService,
         newsLoadingService: NewsLoadingService)
    
    func didLoad()
}

class NewsFeedPresenterImpl: NewsFeedPresenter {
    
    private weak var view: NewsFeedView?
    
    private var newsLoadingService: NewsLoadingService
    private var databaseService: DatabaseService
    
    private var isLazyLoadingInProgress = false
    private var pageNumber: UInt = 1
    
    var newsTablePresenter: NewsTablePresenterImpl! {
        didSet {
            newsTablePresenter.delegate = self
        }
    }
    
    // MARK: Constructors
    required init(view: NewsFeedView,
                  databaseService: DatabaseService = resolve(),
                  newsLoadingService: NewsLoadingService = resolve()) {
        self.view = view
        self.databaseService = databaseService
        self.newsLoadingService = newsLoadingService
    }
    
    func didLoad() {
        view?.showLoadingPageView()
        _ = newsLoadingService.newsList(page: pageNumber)
            .done { (newsResponse) in
                guard !newsResponse.articles.isEmpty else {
                    self.view?.hideLoadingPageView()
                    return
                }
                
                self.newsTablePresenter.news.append(contentsOf: newsResponse.articles)
                self.updatePageNumber()
                _ = self.updateStorage(newsResponse)
                self.view?.hideLoadingPageView()
            }
            .catch {
                self.view?.hideLoadingPageView()
                self.handleLoadingError($0)
        }
    }
}

// MARK: NewsTablePresenterDelegate
extension NewsFeedPresenterImpl: NewsTablePresenterDelegate {
    
    func newsTablePresenterDidPulledForRefresh(presenter: NewsTablePresenter) {
        reloadNews()
    }
    
    func newsTablePresenterWillFinishDisplaying(presenter: NewsTablePresenter) {
        if !isLazyLoadingInProgress {
            isLazyLoadingInProgress = true
            
            _ = newsLoadingService.newsList(page: pageNumber)
                .done { (newsResponse) in
                    guard !newsResponse.articles.isEmpty else {
                        return
                    }
                    
                    self.updatePageNumber()
                    self.newsTablePresenter.news.append(contentsOf: newsResponse.articles)
                    self.isLazyLoadingInProgress = false
                }
                .catch {
                    self.isLazyLoadingInProgress = false
                    self.handleLoadingError($0)
            }
        }
    }
    
    func newsTablePresenterDidSelectNews(news: News, presenter: NewsTablePresenter) {
        view?.openNewsDetails(news: news)
    }
    
    func newsTablePresenterDidScroll(presenter: NewsTablePresenter) { }
    
}

// MARK: Private fucntions
private extension NewsFeedPresenterImpl {
    
    func reloadNews() {
        updatePageNumber(reload: true)
        
        _ = newsLoadingService.newsList(page: pageNumber)
            .done { (newsResponse) in
                guard !newsResponse.articles.isEmpty else {
                    return
                }
            
                self.updatePageNumber()
                self.newsTablePresenter.news = Array(newsResponse.articles)
                _ = self.updateStorage(newsResponse)
            }
            .catch { self.handleLoadingError($0) }
    }

    func updatePageNumber(reload: Bool = false) {
        pageNumber = reload ? 1 : (pageNumber + 1)
    }

    func updateStorage(_ newsResponse: NewsResponse) -> Promise<Void> {
        // check storage whether it contains the data
        let newsResponsePromise: Promise<[NewsResponse]> = databaseService.load()
        return newsResponsePromise
            // it does, so we update the NewsResponse object's articles, in particular.
            // Yeah, it will store only the 20 last results
            // as IMHO there's no need to store all the articles (at least, in this case)
            .done { data in
                if let newsResponse = data.first {
                    _ = self.databaseService.update(object: newsResponse, {
                        $0.articles.removeAll()
                        $0.articles.append(objectsIn: newsResponse.articles)
                    } )
                } else {
                    // it doesn't, so we simply add the new object to storage
                    _ = self.databaseService.add(object: newsResponse)
                }
            }
    }
    
    func handleLoadingError(_ error: Error) {
        if let _ = error as? NetworkServiceError {
            _ = newsLoadingService.savedNewsList()
                .done { self.newsTablePresenter.news = $0 }
        }
    }
}
