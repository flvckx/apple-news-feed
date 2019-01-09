//
//  UIButtonExt.swift
//  NewsFeed
//
//  Created by Serhii Palash on 20/11/2018.
//  Copyright © 2018 Serhii Palash. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    
    @IBInspectable var radius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = radius
            layer.masksToBounds = radius > 0
        }
    }
}
