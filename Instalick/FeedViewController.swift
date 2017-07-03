//
//  FeedViewController.swift
//  Instalick
//
//  Created by Patrick Montalto on 7/1/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    // MARK: - Properties
    fileprivate(set) var feedItems = [FeedItem]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var apiClient = APIClient()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FeedItemCell.self, forCellReuseIdentifier: FeedItemCell.reuseIdentifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Set up view
        setupUI()
        
        // Get Data
        getFeed(fromClient: apiClient)
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        
        // Constraints
        NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
    }
    

    /// Retrieve the feed items from the client
    func getFeed<Client: Gettable> (fromClient client: Client) where Client.Data == FeedItem {
        client.getArray { [weak self] (result) in
            switch result {
            case .success(let feedItems):
                self?.feedItems = feedItems
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:FeedItemCell.reuseIdentifier, for: indexPath) as! FeedItemCell
        
        // Obtain the feed item for the row.
        let feedItem = feedItems[indexPath.row]
        
        // Set the view model on the cell with the feed item.
        cell.viewModel = FeedItemCell.ViewModel(title: feedItem.title,
                                                thumbnailImage: nil,
                                                image: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Present a detail view for the feed item.
    }
    
}
