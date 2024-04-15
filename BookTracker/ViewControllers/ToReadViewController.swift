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
        do {
            let booksToRead = try PersistenceManager.getBooksToRead()
            updateUI(with: booksToRead, emptyView: emptyView)
        } catch {
            presentBTAlertOnMainThread(for: error)
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
        // Swipe to remove the book from "To Read".
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, view, handler in
            guard let self else {return }
            guard let bookToDelete = self.dataSource.itemIdentifier(for: indexPath) else { return }
            
            do {
                // Delete the book from UserDefaults.
                try PersistenceManager.update(book: bookToDelete, actionType: .delete)
                // Remove the book from the data source.
                self.books.removeAll(where: { $0 == bookToDelete })
                self.updateUI(with: self.books, animatingDifferences: true, emptyView: emptyView)
            } catch {
                presentBTAlertOnMainThread(for: error)
            }
        }
        
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}
