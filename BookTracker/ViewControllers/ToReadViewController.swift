//
//  ToReadViewController.swift
//  BookTracker
//
//  Created by Jack Radford on 05/04/2024.
//

import UIKit

class ToReadViewController: BTBookTableViewController {
    
    private let emptyView = BTEmptyStateView(
        systemName: "books.vertical.fill",
        title: "No Books Saved",
        subTitle: "Search for a book and add it."
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "To Read"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getBooksToRead()
    }
    
    // MARK: - Private Functions
    
    private func getBooksToRead() {
        let booksToReadResult = PersistenceManager.getBooksToRead()
        switch booksToReadResult {
        case .success(let books):
            updateUI(with: books, emptyView: emptyView)
        case .failure(let btError):
            presentBTAlertOnMainThread(message: btError.rawValue)
        }
    }
    
}

// MARK: - UITableViewDelegate

extension ToReadViewController {
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
            let btError = PersistenceManager.update(book: bookToDelete, actionType: .delete)
            if let btError {
                presentBTAlertOnMainThread(message: btError.rawValue)
            } else {
                // Remove the book from the data source.
                self.books.removeAll(where: { $0 == bookToDelete })
                self.updateUI(with: self.books, animatingDifferences: true, emptyView: emptyView)
            }
        }
        
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}
