//
//  NewsTableView.swift
//  NewsFeed
//
//  Created by Serhii Palash on 10/11/2018.
//  Copyright © 2018 Serhii Palash. All rights reserved.
//

import UIKit

protocol NewsTableView: View {
    func showNewsAt(index: Int)
    func showNews()
    func showRefreshIndicator()
    func hideRefreshIndicator()
    func showLazyLoadIndicator()
    func hideLazyLoadIndicator()
    func scrollToTop()
}

class NewsTableViewImpl: UITableView {
    
    var presenter: NewsTablePresenter!
    
    private let refreshIndicatorSize = CGSize(width: 40, height: 10)
    private let footerHeight: CGFloat = 40
    
    private var refreshControlContainer: UIRefreshControl!
    private var refreshIndicator: UIActivityIndicatorView!
    private var lazyLoadIndicator: UIActivityIndicatorView!
    
    override init(frame: CGRect, style: Style) {
        super.init(frame: frame, style: style)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configure()
    }
    
    private func configure() {
        let identifier = String(describing: NewsTableViewCell.self)
        let nib = UINib(nibName: identifier, bundle:nil)
        self.register(nib, forCellReuseIdentifier: identifier)
        self.estimatedRowHeight = NewsTableViewCellImpl.height
        self.rowHeight = UITableView.automaticDimension
        self.contentInset =  UIEdgeInsets(top: 7, left: 0, bottom: 0, right: 0)
        self.delegate = self
        self.dataSource = self
        
        initRefreshIndicator()
        self.addSubview(refreshControlContainer)
        initLazyLoadIndicator()
    }
    
    private func initRefreshIndicator() {
        refreshControlContainer = UIRefreshControl()
        refreshControlContainer.tintColor = UIColor.clear
        
        let refreshIndicatorFrame = CGRect(x: 0,
                                           y: 0,
                                           width: refreshIndicatorSize.width,
                                           height: refreshIndicatorSize.height)
        
        refreshIndicator = UIActivityIndicatorView(frame: refreshIndicatorFrame)
        refreshIndicator.tintColor = .sweetPink
        refreshIndicator.stopAnimating()
        refreshControlContainer.addSubview(refreshIndicator)
        
        refreshControlContainer.addTarget(self, action:#selector(onRefresh), for: .valueChanged)
    }
    
    private func initLazyLoadIndicator() {
        lazyLoadIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 10))
        lazyLoadIndicator.tintColor = .sweetPink
        lazyLoadIndicator.stopAnimating()
    }
    
    @objc private func onRefresh() {
        presenter.didPulledForRefresh()
    }
    
    func scrollToTop() {
        if presenter.newsCount > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
    
}

extension NewsTableViewImpl: NewsTableView {
    
    func showRefreshIndicator() {
        refreshIndicator.center = CGPoint(x: refreshControlContainer.frame.size.width / 2,
                                          y: refreshControlContainer.frame.size.height / 2 + refreshIndicator.frame.size.height
        )
        refreshIndicator.startAnimating()
    }
    
    func hideRefreshIndicator() {
        refreshControlContainer.endRefreshing()
        refreshIndicator.stopAnimating()
    }
    
    func showLazyLoadIndicator() {
        let view = UIView()
        var frame = view.frame
        frame.size = CGSize(width: self.frame.width, height: footerHeight)
        view.frame = frame
        view.addSubview(lazyLoadIndicator)
        
        lazyLoadIndicator.center = view.center
        lazyLoadIndicator.startAnimating()
        
        self.tableFooterView = view
    }
    
    func hideLazyLoadIndicator() {
        refreshIndicator.stopAnimating()
        self.tableFooterView = nil
    }
    
    func showNews() {
        self.reloadData()
    }
    
    func showNewsAt(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        self.reloadRows(at: [indexPath], with: .none)
    }
    
}

extension NewsTableViewImpl: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.newsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: NewsTableViewCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? NewsTableViewCellImpl else {
            fatalError("Unable to dequeue reusable cell with NewsTableViewCellImpl identifier.")
        }
        
        let news = presenter.newsFor(index: indexPath.row)
        let cellPresenter = NewsTableViewCellPresenterImpl(view: cell, news: news)
        cell.presenter = cellPresenter
        cell.willDisplay()
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter.willDisplayNewsAt(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectNewsAt(index: indexPath.row)
    }
}

extension NewsTableViewImpl: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        presenter.didScroll()
    }
}

