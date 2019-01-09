//
//  NewsSceneRouter.swift
//  NewsFeed
//
//  Created by Serhii Palash on 13/11/2018.
//  Copyright © 2018 Serhii Palash. All rights reserved.
//

import UIKit

protocol NewsSceneRouter {
    init(viewController: UIViewController)
    
    func navigateToNewsDetails(_ news: News)
}

final class NewsSceneRouterImpl: NewsSceneRouter {
    
    unowned var viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    private func show(_ viewController: UIViewController) {
        self.viewController.navigationController?.show(viewController, sender: nil)
    }
    
    func navigateToNewsDetails(_ news: News) {
        guard let newsDetailsViewController = AppRouter.NewsScene().newsDetailsViewController else {
            return
        }
        
        let newsDetailsPresenter = NewsDetailsPresenterImpl(view: newsDetailsViewController, article: news)
        newsDetailsViewController.presenter = newsDetailsPresenter
        
        show(newsDetailsViewController)
    }
}
