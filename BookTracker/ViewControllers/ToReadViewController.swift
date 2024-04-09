//
//  ToReadViewController.swift
//  BookTracker
//
//  Created by Jack Radford on 05/04/2024.
//

import UIKit

class ToReadViewController: GFDataLoadingViewController {
    typealias DataSource = UITableViewDiffableDataSource<Section, Book>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Book>
    
    enum Section {
        case main
    }
    
    private let tableView = UITableView()
    private var booksToRead = [Book]()
    private var dataSource: DataSource!
    
    private var emptyStateView: BTEmptyStateView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getBooksToRead()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "To Read"
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
    
    private func getBooksToRead() {
        let booksToReadResult = PersistenceManager.getBooksToRead()
        switch booksToReadResult {
        case .success(let books):
            updateUI(with: books)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    private func updateUI(with books: [Book]) {
        self.booksToRead = books
        self.updateData(with: self.booksToRead)
    }
    
    private func updateData(with books: [Book], animatingDifferences: Bool = false) {
        if books.isEmpty {
            showEmptyStateView()
        } else {
            removeEmptyStateView()
        }
        
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(books)
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        }
    }
    
    private func showEmptyStateView() {
        emptyStateView = BTEmptyStateView(
            systemName: "books.vertical.fill",
            title: "No Books Saved",
            subTitle: "Search for a book you would like to read and add it."
        )
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

extension ToReadViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let book = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let destinationViewController = BookDetailsViewController(book: book, mode: .toRead)
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, view, handler in
            guard let self else {return }
            guard let bookToDelete = self.dataSource.itemIdentifier(for: indexPath) else { return }
            
            // Delete the book from UserDefaults.
            let error = PersistenceManager.update(book: bookToDelete, actionType: .delete)
            if let error {
                print(error.localizedDescription)
            } else {
                // Remove the book from the data source.
                self.booksToRead.removeAll(where: { $0 == bookToDelete })
                self.updateData(with: self.booksToRead, animatingDifferences: true)
            }
        }
        
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}
