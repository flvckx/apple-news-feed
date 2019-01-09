//
//  UIViewExt.swift
//  NewsFeed
//
//  Created by Serhii Palash on 20/11/2018.
//  Copyright © 2018 Serhii Palash. All rights reserved.
//

import UIKit

fileprivate let gradientLayerKey = "gradientLayer"

extension UIView {
    
    func addGradient(from colors: [UIColor], type gradientType: GradientType) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = gradientType.x
        gradientLayer.endPoint = gradientType.y
        gradientLayer.frame = bounds
        gradientLayer.name = gradientLayerKey
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func removeGradient() {
        layer.sublayers?.forEach {
            if $0.name == gradientLayerKey {
                $0.removeFromSuperlayer()
            }
        }
    }
}
