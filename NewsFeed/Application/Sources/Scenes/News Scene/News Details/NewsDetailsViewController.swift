//
//  NewsDetailsViewController.swift
//  NewsFeed
//
//  Created by Serhii Palash on 13/11/2018.
//  Copyright © 2018 Serhii Palash. All rights reserved.
//

import SDWebImage
import UIKit

protocol NewsDetailsView: View {
    func showArticleImage(_ imageURL: URL)
    func showArticleAuthor(_ author: String)
    func showArticleDate(_ date: String)
    func showArticleTitle(_ title: String)
    func showArticleContent(_ content: NSAttributedString)
}

final class NewsDetailsViewImpl: UIViewController, NewsDetailsView {
    
    //  MARK: Outlets
    @IBOutlet private weak var articleImageView: UIImageView!
    @IBOutlet private weak var articleAuthor: UILabel!
    @IBOutlet private weak var articleDate: UILabel!
    @IBOutlet private weak var articleTitle: UILabel!
    @IBOutlet private weak var articleContent: UILabel!
    
    var presenter: NewsDetailsPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.showArticle()
    }
    
    func showArticleImage(_ imageURL: URL) {
        articleImageView.sd_setImage(with: imageURL)
    }
    
    func showArticleAuthor(_ author: String) {
        articleAuthor.text = author
    }
    
    func showArticleDate(_ date: String) {
        articleDate.text = date
    }
    
    func showArticleTitle(_ title: String) {
        articleTitle.text = title
    }
    
    func showArticleContent(_ content: NSAttributedString) {
        articleContent.attributedText = content
    }
}

// MARK: Actions
private extension NewsDetailsViewImpl {
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let text = (articleContent.text)!
        let moreRange = (text as NSString).range(of: "more")
        
        if gesture.didTapAttributedText(in: articleContent, targetRange: moreRange) {
            presenter.openFullSource()
        }
    }
    
    @IBAction func openNewsInSafari() {
        presenter.openFullSource()
    }
}
