//
//  FeedDetailViewController.swift
//  Instalick
//
//  Created by Patrick Montalto on 7/3/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

final class FeedDetailViewController: UIViewController {
    
    /// Holds the data and logic needed to populate a `FeedDetailViewController`.
    struct ViewModel {
        
        /// The title of the feed item.
        let title: String
    
        /// The photo for the feed item.
        var photo: UIImage?
    }
    
    // MARK: - Properties
    
    /// The view's model. Set this value to update the data displayed in the view
    var viewModel: ViewModel! {
        didSet {
            titleLabel.attributedText = viewModel.attributedTitleString
            photoImageView.image = viewModel.photo ?? #imageLiteral(resourceName: "blank_600")
            viewModel.photo == nil ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
            
            // Update photoImageView height constraint
            guard let photo = viewModel.photo else { return }
            // TODO: Move to another method
            let scaleFactor = self.view.bounds.width / photo.size.width
            let photoImageViewHeight = scaleFactor * photo.size.height
            photoImageViewHeightConstraint.constant = photoImageViewHeight
        }
    }
    
    /// The constraint for the photo image view's height.
    lazy var photoImageViewHeightConstraint: NSLayoutConstraint = {
        NSLayoutConstraint(item: self.photoImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.view.bounds.width)
    }()
    
    /// The title label for the feed item.
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// The scrollview container for all views.
    fileprivate lazy var containerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    /// The content view for the container scrollView.
    fileprivate lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    /// The image view for the post's photo.
    fileprivate lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// The activity indicator used with the placeholder image.
    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Post"
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        // Setup view hierarchy
        view.addSubview(containerScrollView)
        containerScrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(photoImageView)
        
        // Constraints
        
        // Container ScrollView
        NSLayoutConstraint(item: containerScrollView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: containerScrollView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: containerScrollView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: containerScrollView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        // Content View
        NSLayoutConstraint(item: contentView, attribute: .leading, relatedBy: .equal, toItem: containerScrollView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal, toItem: containerScrollView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: containerScrollView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: containerScrollView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: containerScrollView, attribute: .width, multiplier: 1, constant: 0).isActive = true
        
        // Title label
        NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: titleLabel, attribute: .trailing, multiplier: 1, constant: 16).isActive = true
        
        // Photo imageView
        NSLayoutConstraint(item: photoImageView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: photoImageView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: photoImageView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        photoImageViewHeightConstraint.isActive = true
        NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: photoImageView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }
    
}
// MARK: - UIScrollViewDeleegate
extension FeedDetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
}

// MARK: - Feed Item View Model Presentation Logic
extension FeedDetailViewController.ViewModel: TitleStringAttributable {}
