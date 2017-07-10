//
//  TitleStringAttributable.swift
//  Instalick
//
//  Created by Patrick Montalto on 7/10/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

/// A type with a customized attributed string used to represent it's title.
protocol TitleStringAttributable {
    var title: String { get }
    var attributedTitleString: NSAttributedString { get }
}

extension TitleStringAttributable {
    var attributedTitleString: NSAttributedString {
        let titleFont = UIFont.preferredFont(forTextStyle: .headline)
        let titleColor = UIColor.black
        let attributedString = NSAttributedString(string: title, attributes: [NSFontAttributeName: titleFont, NSForegroundColorAttributeName: titleColor])
        
        return attributedString
    }
}
