//
//  StringExt.swift
//  NewsFeed
//
//  Created by Serhii Palash on 11/11/2018.
//  Copyright © 2018 Serhii Palash. All rights reserved.
//

import Foundation

extension String {
    
    var utf8Encoded: Data {
        return data(using: .utf8) ?? Data()
    }
}
