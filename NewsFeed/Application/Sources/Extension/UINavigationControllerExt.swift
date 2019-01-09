//
//  UINavigationControllerExt.swift
//  NewsFeed
//
//  Created by Serhii Palash on 17/11/2018.
//  Copyright © 2018 Serhii Palash. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.tintColor = .darkGray
        navigationBar.backgroundColor = .sweetPink
    }
}
