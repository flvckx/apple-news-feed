//
//  NewsFeedViewController.swift
//  NewsFeed
//
//  Created by Serhii Palash on 10/11/2018.
//  Copyright © 2018 Serhii Palash. All rights reserved.
//

import UIKit

protocol NewsFeedView: View {
    func showNewsTableView()
    func hideNewsTableView()
    func openNewsDetails(news: News)
    func showLoadingPageView()
    func hideLoadingPageView()
}

final class NewsFeedViewControllerImpl: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet private weak var feedTableView: NewsTableViewImpl!
    
    // MARK: Properties
    var presenter: NewsFeedPresenterImpl!
    var router: NewsSceneRouter!
    
    var loadingPageView: LoadingPageView?
    
    // MARK: Virtual functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        router = NewsSceneRouterImpl(viewController: self)
        
        let newsTablePresenter = NewsTablePresenterImpl(view: feedTableView)
        feedTableView.presenter = newsTablePresenter
        presenter.newsTablePresenter = newsTablePresenter
        
        loadingPageView = LoadingPageView(frame: self.view.frame)
        loadingPageView?.loadingText = "Synching.."
        
        presenter.didLoad()
    }
}

extension NewsFeedViewControllerImpl: NewsFeedView {
    
    func openNewsDetails(news: News) {
        router.navigateToNewsDetails(news)
    }
    
    func showNewsTableView() {
        feedTableView.isHidden = false
    }
    
    func hideNewsTableView() {
        feedTableView.isHidden = true
    }
    
    func showLoadingPageView() {
        UIApplication.shared.keyWindow?.addSubview(loadingPageView!)
        loadingPageView?.show(completion: nil)
    }
    
    func hideLoadingPageView() {
        loadingPageView?.hide(completion: {
            self.loadingPageView?.removeFromSuperview()
        })
    }
}

