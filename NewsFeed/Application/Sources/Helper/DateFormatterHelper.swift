//
//  DateFormatterHelper.swift
//  NewsFeed
//
//  Created by Serhii Palash on 15/11/2018.
//  Copyright © 2018 Serhii Palash. All rights reserved.
//

import Foundation

enum DateFormatType: String {
    case received = "yyyy-MM-dd'T'HH:mm:ssZ"
    case show = "MMM d, yyyy h:mm a"
}

class DateFormatterHelper {
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        return formatter
    }()
    
    func string(from: Date, format: DateFormatType) -> String {
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: from)
    }
    
    func date(from: String, format: DateFormatType) -> Date? {
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.date(from: from)
    }
}

