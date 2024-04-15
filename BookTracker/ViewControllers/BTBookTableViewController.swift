//
//  BTBookTableViewController.swift
//  BookTracker
//
//  Created by Jack Radford on 09/04/2024.
//

import UIKit

/// Configures the TableView and DataSource for Book tables with BookTableViewCells,
/// and provides functions for updating the UI and showing/ removing the empty state views.
class BTBookTableViewController: BTDataLoadingViewController {
    typealias DataSource = UITableViewDiffableDataSource<Section, Book>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Book>
    
    enum Section {
        case main
    }
    
    private let tableView = UITableView()
    private var emptyStateView: BTEmptyStateView?
    
    var books = [Book]()
    var dataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        configureDataSource()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureDataSource() {
        dataSource = DataSource(tableView: tableView, cellProvider: { tableView, indexPath, book in
            let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.reuseID, for: indexPath) as! BookTableViewCell
            cell.set(book: book)
            return cell
        })
        dataSource.defaultRowAnimation = .fade
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.frame = view.bounds
        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.reuseID)
        tableView.rowHeight = 80
    }
    
    func updateUI(with books: [Book], animatingDifferences: Bool = false, emptyView: BTEmptyStateView) {
        self.books = books
        // Show the empty state view if there are not books.
        if books.isEmpty {
            showEmptyStateView(with: emptyView)
        } else {
            removeEmptyStateView()
        }
        
        // Update the snapshot.
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(books)
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        }
    }
    
    func showEmptyStateView(with emptyView: BTEmptyStateView) {
        // Remove first incase it is already presented.
        removeEmptyStateView()
        self.emptyStateView = emptyView
        guard let emptyStateView else { return }
        view.addSubview(emptyStateView)
        
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func removeEmptyStateView() {
        emptyStateView?.removeFromSuperview()
        emptyStateView = nil
    }
}

// MARK: - UITableViewDelegate

extension BTBookTableViewController: UITableViewDelegate {}
