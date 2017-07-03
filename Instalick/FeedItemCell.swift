//
//  FeedItemCell.swift
//  Instalick
//
//  Created by Patrick Montalto on 7/1/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

/// Displays an individual feed item using it's thumbnail as a preview.
final class FeedItemCell: UITableViewCell {
    
    /// Holds the data and logic needed to ppulate a `FeedItemCell`.
    struct ViewModel {
        
        /// The title of the feed item.
        let title: String
        
        /// The thumbnail image for the feed item.
        var thumbnailImage: UIImage?
        
        /// The image for the feed item.
        var image: UIImage?
    }
    
    static let reuseIdentifier = String(describing: type(of: self))
    
    // MARK: - Properties
    
    /// The view's model. Set this value to update the data displayed in the view
    var viewModel: ViewModel? {
        didSet {
            titleLabel.attributedText = viewModel?.attributedTitleString
            thumbnailImageView.image = viewModel?.thumbnailImage
        }
    }
    
    /// The label for the title of the feed item.
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    /// The image view of the feed item's thumbnail.
    lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(thumbnailImageView)
        
        // Constraints
        NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: titleLabel, attribute: .trailing, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: thumbnailImageView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: thumbnailImageView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: thumbnailImageView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
    }
}

// MARK: - Feed Item View Model Presentation Logic 
extension FeedItemCell.ViewModel {
    
    /// Attributed string representing the title of the feed item.
    var attributedTitleString: NSAttributedString {
        let titleFont = UIFont.preferredFont(forTextStyle: .headline)
        let titleColor = UIColor.black
        let attributedString = NSAttributedString(string: title, attributes: [NSFontAttributeName: titleFont, NSForegroundColorAttributeName: titleColor])
        
        return attributedString
    }
}
