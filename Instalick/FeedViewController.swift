//
//  FeedViewController.swift
//  Instalick
//
//  Created by Patrick Montalto on 7/1/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit
import SDWebImage

/// The main view controller for the application.
/// Presents a `UITableView` which displays the contents of a JSON
/// photos endpoint.
class FeedViewController: UIViewController {
    
    // MARK: - Properties
    
    /// The `FeedItems` array used as the `tableView` data source.
    fileprivate(set) var feedItems = [FeedItem]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    /// The client used to retrieve data from the API.
    var apiClient = APIClient()

    /// The `UITableView` which displays the feed items.
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FeedItemCell.self, forCellReuseIdentifier: FeedItemCell.reuseIdentifier)
        tableView.refreshControl = self.refreshControl
        let backgroundView = EmptyBackgroundView(frame: self.view.frame)
        backgroundView.iconImage = #imageLiteral(resourceName: "home")
        backgroundView.titleText = "Home"
        backgroundView.captionText = "This is where the posts in your feed would go...if you had any!"
        tableView.backgroundView = backgroundView
        return tableView
    }()
    
    /// The refreshControl for the feed tableView.
    lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
        return control
    }()
    
    /// The presentation state of the toast message.
    var toastDisplayed = false
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Set up view
        setupUI()
        
        // Used cached data first
        feedItems = apiClient.cachedFeedItems() ?? []
        
        // Get data if necessary
        refreshControl.beginRefreshingManually()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if refreshControl.isRefreshing {
            let offset = self.tableView.contentOffset
            
            refreshControl.endRefreshing()
            refreshControl.beginRefreshing()
            tableView.contentOffset = offset
        }
    }

    /// Sets up the constraints and view hierarchy.
    private func setupUI() {
        view.addSubview(tableView)
        
        // Constraints
        NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
    }

    /// Retrieve the feed items from the client.
    func getFeed<Client: Gettable> (fromClient client: Client) where Client.Data == FeedItem {
        client.getArray { [weak self] (result) in
            switch result {
            case .success(let feedItems):
                self?.feedItems = feedItems
            case .failure:
                DispatchQueue.main.async {
                    self?.toastDisplayed = true
                    self?.showToast(message: "Couldn't Refresh Feed", completion: { (completed) in
                        self?.toastDisplayed = false
                    })
                }
            }
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func refreshControlPulled(_ refreshControl: UIRefreshControl) {
        if toastDisplayed {
            refreshControl.endRefreshing()
            return
        }
        getFeed(fromClient: apiClient)
    }
    
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if feedItems.count == 0 {
            tableView.separatorStyle = .none
            tableView.backgroundView?.isHidden = false
        } else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView?.isHidden = true
        }
        
        return feedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:FeedItemCell.reuseIdentifier, for: indexPath) as! FeedItemCell
        
        // Obtain the feed item for the row.
        let feedItem = feedItems[indexPath.row]
        
        let thumbnailImage = SDImageCache.shared().imageFromCache(forKey: feedItem.thumbnailUrlString)
        
        // Set the view model on the cell with the feed item.
        cell.viewModel = FeedItemCell.ViewModel(title: feedItem.title,
                                                thumbnailImage: thumbnailImage)
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let feedItem = feedItems[indexPath.row]
        guard let thumbnailURL = feedItem.thumbnailURL else { return }
        
        guard let cell = cell as? FeedItemCell, cell.viewModel?.thumbnailImage == nil else {
            return
        }
        
        SDWebImageManager.shared().loadImage(with: thumbnailURL, options: .progressiveDownload, progress: nil) { (image, data, error, cacheType, finished, imageURL) in
            cell.viewModel?.thumbnailImage = image
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Obtain the feed item for the row.
        let feedItem = feedItems[indexPath.row]
        let photo = SDImageCache.shared().imageFromCache(forKey: feedItem.urlString)

        // Create a feed detail view controller
        let feedDetailViewController = FeedDetailViewController()
        feedDetailViewController.viewModel = FeedDetailViewController.ViewModel(title: feedItem.title, photo: photo)
        
        // Check if image doesn't exist in the cache
        if let photoURL = feedItem.photoURL, photo == nil {
            SDWebImageManager.shared().loadImage(with: photoURL, options: .progressiveDownload, progress: nil, completed: { [weak feedDetailViewController] (image, data, error, cacheType, finished, imageURL) in
                feedDetailViewController?.viewModel.photo = image
            })
        }
        
        navigationController?.pushViewController(feedDetailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
