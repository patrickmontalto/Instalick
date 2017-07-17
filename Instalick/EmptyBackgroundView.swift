//
//  EmptyBackgroundView.swift
//  Instalick
//
//  Created by Patrick Montalto on 7/17/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

/// A view used for the `UITableView` empty state.
class EmptyBackgroundView: UIView {
    
    // MARK: - Properties
    var iconImage: UIImage? {
        didSet {
            guard let iconImage = iconImage else {
                return
            }
            let image = iconImage.withRenderingMode(.alwaysTemplate)
            iconView.image = image
        }
    }
    
    /// The title string for the view.
    var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    /// The caption string for the view.
    var captionText: String? {
        didSet {
            detailLabel.text = captionText
        }
    }
    
    /// The image used for the empty state background view.
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// The title label for the empty state background view.
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 24.0)
        label.textColor = .gray
        return label
    }()
    
    /// The detail label for the empty state background view.
    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18.0)
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    /// Sets up view hierarchy and constraints
    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [iconView, titleLabel, detailLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fill
        stackView.alignment = .center
        
        addSubview(stackView)
        
        NSLayoutConstraint(item: stackView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: stackView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.frame.width - 48).isActive = true
        NSLayoutConstraint(item: stackView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }
    
}
