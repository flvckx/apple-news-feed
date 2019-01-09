//
//  NewsDetailsPresenter.swift
//  NewsFeed
//
//  Created by Serhii Palash on 13/11/2018.
//  Copyright © 2018 Serhii Palash. All rights reserved.
//

import Foundation
import UIKit

protocol NewsDetailsPresenter: Presenter {
    init(view: NewsDetailsView,
         article: News)
    
    func showArticle()
    func openFullSource()
}

final class NewsDetailsPresenterImpl: NewsDetailsPresenter {
    
    unowned private var view: NewsDetailsView
    
    private var article: News
    
    required init(view: NewsDetailsView,
                  article: News) {
        self.view = view
        self.article = article
    }
    
    func showArticle() {
        view.showArticleAuthor(article.author ?? "")
        view.showArticleTitle(article.title ?? "")
        
        setUpArticleDate()
        setUpArticleContent()
        
        guard
            let stringURL = article.urlToImage,
            let url = URL(string: stringURL) else {
                return
        }
        view.showArticleImage(url)
    }
    
    func openFullSource() {
        guard
            let link = article.url,
            let url = URL(string: link) else {
                return
        }
        
        UIApplication.shared.open(url)
    }
}
// MARK: Private methods
private extension NewsDetailsPresenterImpl {
    
    func setUpArticleDate() {
        let dateFormatterHelper = DateFormatterHelper()
        guard let date = dateFormatterHelper.date(from: article.publishedAt ?? "", format: .received) else {
            return
        }
        
        let userFriendlyDate = dateFormatterHelper.string(from: date, format: .show)
        view.showArticleDate(userFriendlyDate.description)
    }
    
    func setUpArticleContent() {
        guard let content = article.content else {
            return
        }
        
        let link = URL(string: article.url ?? "")
        let updatedContent = ContentEditor.pasteFullSource(link, text: content)
        
        view.showArticleContent(updatedContent)
    }
}
