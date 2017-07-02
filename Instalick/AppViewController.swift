//
//  AppViewController.swift
//  Instalick
//
//  Created by Patrick Montalto on 6/29/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

/// Sits in the window and monitors application state.
/// Changes child view controllers depending on application state.
final class AppViewController: UIViewController {

    private lazy var behavior: ChildViewControllerBehavior = {
        ChildViewControllerBehavior(parentViewController: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view in which all children will be installed.
        behavior.view.frame = view.bounds
        behavior.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(behavior.view)
        
        
//        behavior.childViewController =
    }
}
