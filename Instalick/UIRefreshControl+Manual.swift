//
//  UIRefreshControl+Manual.swift
//  Instalick
//
//  Created by Patrick Montalto on 7/16/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

extension UIRefreshControl {
    func beginRefreshingManually() {
        if let scrollView = superview as? UIScrollView {
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - frame.height), animated: true)
        }
        beginRefreshing()
        sendActions(for: .valueChanged)
    }
}
