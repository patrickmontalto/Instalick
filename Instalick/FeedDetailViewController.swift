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
            updatePhotoImageViewHeight(withPhoto: photo)
        }
    }
    
    /// The constraint for the photo image view's height.
    lazy var photoImageViewHeightConstraint: NSLayoutConstraint = {
        NSLayoutConstraint(item: self.photoImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.view.bounds.width)
    }()
    
    /// The constraint for the photo image view background's height.
    lazy var photoImageBackgroundHeightConstraint: NSLayoutConstraint = {
        NSLayoutConstraint(item: self.photoImageBackgroundView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.view.bounds.width)
    }()
    
    /// The title label for the feed item.
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// The scrollview container for all views.
    private lazy var containerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    /// The content view for the container scrollView.
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// The image view for the post's photo.
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// A background view used to maintain scrollview size during photo user interaction.
    private lazy var photoImageBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    /// The activity indicator used with the placeholder image.
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    /// The pinch gesture for the photo image view.
    private lazy var pinchGesture: UIPinchGestureRecognizer = {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(scaleImage(_:)))
        pinchGesture.delegate = self
        return pinchGesture
    }()
    
    /// The pan gesture for the photo image view.
    private lazy var panGesture: UIPanGestureRecognizer = {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panImage(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 2
        return panGesture
    }()
    
    /// The dimming view displayed when the photo is being zoomed or panned.
    private lazy var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.frame = self.view.frame
        view.alpha = 0
        return view
    }()
    
    /// The original center point of the photoImageView used for panning.
    private var photoImageOrigin: CGPoint?
    
    /// The original index of the photo image view in the view hierarchy.
    private var photoImageIndex: IndexPath?
    
    /// The current scale of the photo image view.
    private var photoImageViewScale: CGFloat {
        return photoImageView.layer.value(forKeyPath: "transform.scale.x") as! CGFloat
    }
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide logo
        (navigationController as? ILNavigationController)?.logoIsHidden = true
        title = "Post"
        view.backgroundColor = .white
        setupUI()

        // Add pinch gesture
        photoImageView.isUserInteractionEnabled = true
        photoImageView.addGestureRecognizer(pinchGesture)
        
        // Add pan gesture
        photoImageView.addGestureRecognizer(panGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        photoImageOrigin = photoImageView.frame.origin
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dimmingView.removeFromSuperview()
    }

    // MARK: - UI Setup
    
    /// Updates the height constraint of the `photoImageView` and `photoImageBackgroundView`
    /// based on the size of the provided image.
    private func updatePhotoImageViewHeight(withPhoto photo: UIImage) {
        let scaleFactor = self.view.bounds.width / photo.size.width
        let photoImageViewHeight = scaleFactor * photo.size.height
        photoImageViewHeightConstraint.constant = photoImageViewHeight
        photoImageBackgroundHeightConstraint.constant = photoImageViewHeight
    }
    
    /// Activates constraints for photoImageView.
    private func activatePhotoImageViewConstraints() {
        // Photo imageView
        NSLayoutConstraint(item: photoImageView, attribute: .top, relatedBy: .equal, toItem: photoImageBackgroundView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: photoImageView, attribute: .leading, relatedBy: .equal, toItem: photoImageBackgroundView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: photoImageView, attribute: .trailing, relatedBy: .equal, toItem: photoImageBackgroundView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
    }
    
    /// Setup view hierarchy and constraints.
    private func setupUI() {
        view.addSubview(containerScrollView)
        containerScrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(photoImageBackgroundView)
        contentView.addSubview(photoImageView)
        let window = UIApplication.shared.keyWindow!
        window.addSubview(dimmingView)
        
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
        
        activatePhotoImageViewConstraints()
        photoImageViewHeightConstraint.isActive = true

        // Photo image background view
        NSLayoutConstraint(item: photoImageBackgroundView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: photoImageBackgroundView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: photoImageBackgroundView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        photoImageBackgroundHeightConstraint.isActive = true
        NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: photoImageBackgroundView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }
    
    // MARK: - Gestures
    
    /// Arranges the `photoImageView` as an immediate subview of the key window.
    private func movePhotoImageViewToFront() {
        let width = photoImageView.frame.width
        let window = UIApplication.shared.keyWindow!
        window.addSubview(photoImageView)
        photoImageView.frame = CGRect(x: photoImageOrigin!.x, y: photoImageOrigin!.y + 64, width: width, height: photoImageViewHeightConstraint.constant)
    }
    
    /// Arranges `photoImageView` as a subview of `contentView`, returning it to the initial default state.
    private func movePhotoImageViewToContentView() {
        // Move photo image view back to content view
        contentView.addSubview(self.photoImageView)
        let width = contentView.frame.width
        activatePhotoImageViewConstraints()
        view.layoutIfNeeded()
        photoImageView.frame = CGRect(x: 0, y: photoImageOrigin!.y, width: width, height: photoImageViewHeightConstraint.constant)
        print(photoImageView.frame)
    }
    
    /// Animates the `photoImageView` returning to it's default state.
    private func resetPhotoImageView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.photoImageView.transform = .identity
            self.photoImageView.frame.origin = CGPoint(x: 0, y: self.photoImageOrigin!.y + 64)
        }, completion: { (completed) in
            self.movePhotoImageViewToContentView()
        })
    }
    
    /// Animates the dimming view while a pinch/pan gesture on `photoImageView`
    // FIXME: Will be called twice.
    private func animateDimmingView(withGesture gesture: UIGestureRecognizer) {
        switch gesture.state {
        case .began:
            movePhotoImageViewToFront()
            dimmingView.alpha = 0.2
        case .changed:
            // min: 0.2, max: 0.6
            let newRange: CGFloat = 0.8 - 0.2
            let oldRange: CGFloat = 2.0 - 1.0
            let newValue = ((photoImageViewScale - 1.0) / oldRange) * newRange + 0.2
            dimmingView.alpha = min(0.8, newValue)
        default:
            dimmingView.alpha = 0
        }
    }
    
    /// Pans the gestured view according to the translation delta of the pan gesture.
    @objc private func panImage(_ panGesture: UIPanGestureRecognizer) {
        guard let panableView = panGesture.view else { return }
        
        animateDimmingView(withGesture: panGesture)
        
        let translation = panGesture.translation(in: panableView.superview)
        
        if panGesture.state == .began || panGesture.state == .changed {
            panableView.center = CGPoint(x: panableView.center.x + translation.x,
                                         y: panableView.center.y + translation.y)
            // Reset translation so we can get translation deltas
            panGesture.setTranslation(.zero, in: panableView)
        } else {
            resetPhotoImageView()
        }
    }
    
    /// Scales the gestured view according to the delta scale of the pinch gesture.
    @objc private func scaleImage(_ pinchGesture: UIPinchGestureRecognizer) {
        guard let scalableView = pinchGesture.view else { return }
        
        animateDimmingView(withGesture: pinchGesture)
        
        if pinchGesture.state == .began || pinchGesture.state == .changed {
            // Move the anchor point of the view's layer to the touch point
            // so that scaling the view and layer becomes simpler.
            self.adjustAnchorPoint(gestureRecognizer: pinchGesture)
            
            let minScale: CGFloat = 1.0
            let maxScale: CGFloat = 4.0
            
            var deltaScale = pinchGesture.scale
            
            // Limit to min/max size (i.e maxScale = 2, current scale = 2, 2/2 = 1.0)
            //  A deltaScale is ~0.99 for decreasing or ~1.01 for increasing
            //  A deltaScale of 1.0 will maintain the zoom size
            deltaScale = min(deltaScale, maxScale / photoImageViewScale)
            deltaScale = max(deltaScale, minScale / photoImageViewScale);
            
            let zoomTransform = scalableView.transform.scaledBy(x: deltaScale, y: deltaScale)
            scalableView.transform = zoomTransform;
            
            // Reset to 1 for scale delta's
            //  Note: not 0, or we won't see a size: 0 * width = 0
            pinchGesture.scale = 1.0;
        } else {
            resetPhotoImageView()
        }
    }
    
    /// Adjusts the anchor point of the gestured view so that scaling occurs around the touches.
    private func adjustAnchorPoint(gestureRecognizer : UIGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let view = gestureRecognizer.view
            let locationInView = gestureRecognizer.location(in: view)
            let locationInSuperview = gestureRecognizer.location(in: view?.superview)
            
            // Move the anchor point to the touch point and change the position of the view
            view?.layer.anchorPoint = CGPoint(x: (locationInView.x / (view?.bounds.size.width)!),
                                              y: (locationInView.y / (view?.bounds.size.height)!))
            view?.center = locationInSuperview
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension FeedDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - Feed Item View Model Presentation Logic
extension FeedDetailViewController.ViewModel: TitleStringAttributable {}
