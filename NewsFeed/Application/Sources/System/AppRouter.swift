//
//  AppRouter.swift
//  NewsFeed
//
//  Created by Serhii Palash on 10/11/2018.
//  Copyright © 2018 Serhii Palash. All rights reserved.
//

import UIKit

struct AppRouter {
    
    struct NewsScene {
        
        private static let storyboard = UIStoryboard(name: "NewsScene", bundle: nil)
        
        private enum Screens: String {
            case news = "NewsNavigationController"
            case newsDetails = "NewsDetailsViewImpl"
        }
        
        let mainNavigationController = storyboard.instantiateViewController(
            withIdentifier: Screens.news.rawValue) as? UINavigationController
        
        let newsDetailsViewController = storyboard.instantiateViewController(
            withIdentifier: Screens.newsDetails.rawValue) as? NewsDetailsViewImpl
    }
}
