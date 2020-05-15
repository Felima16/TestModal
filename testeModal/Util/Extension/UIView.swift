//
//  UIView.swift
//
//  Created by Fernanda de Lima on 14/01/20.
//  Copyright © 2020 Fernanda de Lima. All rights reserved.
//

import UIKit

extension UIView{
    var indicator: UIActivityIndicatorView {
        let screenHeight = UIScreen.main.bounds.height
        var centerViewY = screenHeight / 2
        
        if self.center.y < centerViewY && self.center.y < screenHeight {
            centerViewY = self.center.y
        }
        
        let centerView = CGPoint(x: self.center.x, y: centerViewY)
        let loadIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        loadIndicator.style = .medium
        loadIndicator.hidesWhenStopped = true
        loadIndicator.center = centerView
        loadIndicator.backgroundColor = #colorLiteral(red: 0.3921568627, green: 1, blue: 0.8549019608, alpha: 1)
        loadIndicator.layer.cornerRadius = 10
        addSubview(loadIndicator)
        
        return loadIndicator
    }
    
    func startLoading() {
        DispatchQueue.main.async {
            self.isUserInteractionEnabled = false
            self.indicator.startAnimating()
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
            self.isUserInteractionEnabled = true
            for view in self.subviews where view.isKind(of: UIActivityIndicatorView.self) {
                view.removeFromSuperview()
            }
        }
    }
}
