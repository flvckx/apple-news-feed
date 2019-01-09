//
//  News.swift
//  NewsFeed
//
//  Created by Serhii Palash on 10/11/2018.
//  Copyright © 2018 Serhii Palash. All rights reserved.
//

import RealmSwift

class News: Object, Decodable {
    
    @objc dynamic var source: NewsSource?
    @objc dynamic var author: String?
    @objc dynamic var title: String?
    @objc dynamic var newsDescription: String?
    @objc dynamic var url: String?
    @objc dynamic var urlToImage: String?
    @objc dynamic var publishedAt: String?
    @objc dynamic var content: String?
    
    override static func primaryKey() -> String? {
        return "url"
    }
    
    enum CodingKeys: String, CodingKey {
        case source, author, title, url, urlToImage, publishedAt, content
        case newsDescription = "description"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        source = try values.decodeIfPresent(NewsSource.self, forKey: .source)
        author = try values.decodeIfPresent(String.self, forKey: .author)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        newsDescription = try values.decodeIfPresent(String.self, forKey: .newsDescription)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        urlToImage = try values.decodeIfPresent(String.self, forKey: .urlToImage)
        publishedAt = try values.decodeIfPresent(String.self, forKey: .publishedAt)
        content = try values.decodeIfPresent(String.self, forKey: .content)
    }
}

class NewsSource: Object, Decodable {
    
    @objc dynamic var id: String?
    @objc dynamic var name: String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
}

class NewsResponse: Object, Decodable {
    
    @objc dynamic var id = 1
    
    let articles = List<News>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    enum CodingKeys: String, CodingKey {
        case articles
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let news = try values.decodeIfPresent([News].self, forKey: .articles) ?? []
        articles.append(objectsIn: news)
    }
}
