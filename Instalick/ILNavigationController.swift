//
//  ILNavigationController.swift
//  Instalick
//
//  Created by Patrick Montalto on 7/16/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

/// A `UINavigationController` with custom appearance.
class ILNavigationController: UINavigationController {
    
    /// The logo for the navigation bar.
    lazy var instalickLogoView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Instalick"))
        imageView.contentMode = .scaleAspectFit
        imageView.center.x = self.view.center.x
        imageView.center.y = self.navigationBar.center.y + 18
        return imageView
    }()
    
    /// Determines whether or not the logo view will be hidden.
    var logoIsHidden: Bool! {
        didSet {
            instalickLogoView.isHidden = logoIsHidden
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set appearance
        navigationBar.barTintColor = UIColor.App.brandRed
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationBar.isTranslucent = false
    
        // Set logo
        view.addSubview(instalickLogoView)
        logoIsHidden = false
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        logoIsHidden = !(viewController is FeedViewController)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        let vc = super.popViewController(animated: animated)
        logoIsHidden = false
        return vc
    }
}
