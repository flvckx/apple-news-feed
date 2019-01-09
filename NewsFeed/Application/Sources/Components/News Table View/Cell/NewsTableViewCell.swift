//
//  NewsTableViewCell.swift
//  NewsFeed
//
//  Created by Serhii Palash on 11/11/2018.
//  Copyright © 2018 Serhii Palash. All rights reserved.
//

import SDWebImage
import UIKit

protocol NewsTableViewCell: View {
    func showTitle(title: String)
    func showPreviewText(previewText: String)
    func showImage(imageURL: URL)
}

final class NewsTableViewCellImpl: UITableViewCell, NewsTableViewCell {
    
    // MARK: Constants
    static let height: CGFloat = 118
    
    // MARK: IBOutlet
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var previewTextLabel: UILabel!
    @IBOutlet private weak var articleImage: UIImageView!
    
    // MARK: Properties
    var presenter: NewsTableViewCellPresenter!
    
    // MARK: General functions
    func willDisplay() {
        presenter.showNews()
    }
    
    func showTitle(title: String) {
        titleLabel.text = title
    }
    
    func showPreviewText(previewText: String) {
        previewTextLabel.text = previewText
    }
    
    func showImage(imageURL: URL) {
        articleImage.sd_setImage(with: imageURL)
    }
}

