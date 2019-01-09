//
//  AppFlow.swift
//  NewsFeed
//
//  Created by Serhii Palash on 10/11/2018.
//  Copyright © 2018 Serhii Palash. All rights reserved.
//

import UIKit

class AppFlow {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        showFeedScene()
    }
    
    private func showFeedScene() {
        let newsNavigationController = AppRouter.NewsScene().mainNavigationController
        guard let newsFeedViewController = newsNavigationController?.viewControllers.first as? NewsFeedViewControllerImpl else {
            return
        }
        
        let newsFeedPresenter = NewsFeedPresenterImpl(view: newsFeedViewController)
        newsFeedViewController.presenter = newsFeedPresenter
        
        window.rootViewController = newsNavigationController
        window.makeKeyAndVisible()
    }
}
