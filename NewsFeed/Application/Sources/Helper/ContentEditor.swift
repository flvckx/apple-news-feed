//
//  ContentEditor.swift
//  NewsFeed
//
//  Created by Serhii Palash on 13/11/2018.
//  Copyright © 2018 Serhii Palash. All rights reserved.
//

import Foundation

fileprivate let more = "more"

class ContentEditor: Helper {
    
    // replacing [+n chars] with a link to full article source
    static func pasteFullSource(_ link: URL?, text: String) -> NSAttributedString {
        let content = NSMutableAttributedString(string: text)
        
        guard
            text.last == "]",
            let startIndex = text.lastIndex(of: "[") else {
                return content
        }
        
        let rangeToReplace = startIndex..<text.endIndex
        
        guard let link = link else {
            let content = text.replacingCharacters(in: rangeToReplace, with: "")
            return NSAttributedString(string: content)
        }
        
        let linkAttributes: [NSAttributedString.Key: Any] = [.link: link]
        let linkToPaste = NSAttributedString(string: more, attributes: linkAttributes)
        
        content.replaceCharacters(in: NSRange(rangeToReplace, in: text), with: linkToPaste)
        
        return content
    }
}
