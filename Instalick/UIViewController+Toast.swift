//
//  UIViewController+Toast.swift
//  Instalick
//
//  Created by Patrick Montalto on 7/16/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// Presents a toast message to the user.
    func showToast(message: String, duration: TimeInterval = 2.0) {
        let label = UILabel()
        label.text = message
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
        label.sizeToFit()
        label.frame.size = CGSize(width: view.frame.width, height: 32)
        label.frame.origin = CGPoint(x: 0, y: topLayoutGuide.length - label.frame.height)
        
        view.addSubview(label)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            label.frame.origin = CGPoint(x: 0, y: label.frame.origin.y + label.frame.height)
        }, completion: { (completed) in
            UIView.animate(withDuration: 0.3, delay: duration, options: .curveEaseIn, animations: {
                label.frame.origin = CGPoint(x: 0, y: label.frame.origin.y - label.frame.height)
            }, completion: { (completed) in
                label.removeFromSuperview()
            })
        })
    }
}
