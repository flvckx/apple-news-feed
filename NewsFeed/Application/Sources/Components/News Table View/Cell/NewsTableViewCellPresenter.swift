//
//  NewsTableViewCellPresenter.swift
//  NewsFeed
//
//  Created by Serhii Palash on 11/11/2018.
//  Copyright © 2018 Serhii Palash. All rights reserved.
//

import Foundation

// MARK: Protocols
protocol NewsTableViewCellPresenter: Presenter {
    init(view: NewsTableViewCell,
         news: News)
    
    func showNews()
}

// MARK: Structs
struct NewsTableViewCellPresenterImpl: NewsTableViewCellPresenter {    
    
    unowned private var view: NewsTableViewCell
    
    private var news: News
    
    // MARK: Constructors
    
    init(view: NewsTableViewCell,
         news: News) {
        self.view = view
        self.news = news
    }
    
    // MARK: General functions
    
    func showNews() {
        view.showTitle(title: news.title ?? "")
        view.showPreviewText(previewText: news.newsDescription ?? "")
        
        if let imageURL = news.urlToImage, let url = URL(string: imageURL) {
            view.showImage(imageURL: url)
        }
    }
}

