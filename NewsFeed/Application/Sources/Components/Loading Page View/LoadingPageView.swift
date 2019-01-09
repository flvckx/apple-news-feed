//
//  LoadingPageView.swift
//  NewsFeed
//
//  Created by Serhii Palash on 20/11/2018.
//  Copyright © 2018 Serhii Palash. All rights reserved.
//

import UIKit

@IBDesignable
class LoadingPageView: UIView {
    
    // MARK: IBOutlets
    @IBOutlet private weak var loadingTextLabel: UILabel!
    
    // MARK: Properties
    private var view: UIView!
    
    @IBInspectable
    var loadingText: String = "" {
        didSet {
            loadingTextLabel.text = loadingText
        }
    }
    
    @IBInspectable
    var animating: Bool = true {
        didSet {
            animating ? show(animation: false) : hide(animation: false)
        }
    }
    
    // MARK: Constructors
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }
    
    // MARK: General functions
    func show(animation: Bool = true, completion: (() -> Void)? = nil) {
        let alpha: CGFloat = 1.0
        animation ? animateViewTo(alpha: alpha, completion: completion) : setAlphaTo(alpha: alpha)
    }
    
    func hide(animation: Bool = true, completion: (() -> Void)? = nil) {
        let alpha: CGFloat = 0.0
        animation ? animateViewTo(alpha: alpha, completion: completion) : setAlphaTo(alpha: alpha)
    }
    
    // MARK: private functions
    private func loadXib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: LoadingPageView.self), bundle: bundle)
        view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    private func animate(withDuration duration: TimeInterval,
                         delay: TimeInterval, animationBlock: @escaping () -> Void, completion: (() -> Void)?) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: .curveEaseIn,
                       animations: { () -> Void in
                        animationBlock()
        }, completion: { _ -> Void in
            completion?()
        })
    }
    
    private func animateViewTo(alpha: CGFloat, completion: (() -> Void)?) {
        self.animate(withDuration: 0.2, delay: 0, animationBlock: {
            self.alpha = alpha
        }, completion: {
            completion?()
        })
    }
    
    private func setAlphaTo(alpha: CGFloat) {
        self.alpha = alpha
    }
    
}

