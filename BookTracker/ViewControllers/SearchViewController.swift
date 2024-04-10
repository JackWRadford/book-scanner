//
//  SearchViewController.swift
//  BookTracker
//
//  Created by Jack Radford on 05/04/2024.
//

import UIKit

class SearchViewController: BTBookTableViewController {
    private var query: String?
    private var page = 1
    private var moreBooksAvailable = true
    private var isLoadingMoreBooks = false
    private var isSearching = false
    
    private var emptyView: BTEmptyStateView {
        if isSearching {
            return BTEmptyStateView(
                systemName: "magnifyingglass",
                title: "No Books Found",
                subTitle: "Check spelling or try a new search."
            )
        } else {
            return BTEmptyStateView(
                systemName: "magnifyingglass",
                title: "Search for a Book",
                subTitle: "Search by author, ISBN, or title."
            )
        }
    }
    
    // MARK: - UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
        showEmptyStateView(with: emptyView)
    }
    
    // MARK: - Configuration
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Search by title, author or ISBN"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    // MARK: - Private Functions
    
    private func getBooks(for query: String, page: Int) {
        showLoadingView()
        isLoadingMoreBooks = true
        
        Task {
            do {
                let newBooks = try await NetworkManager.shared.getBooks(for: query, page: page)
                // Append the new books to the existing array of books.
                let books = self.books + newBooks
                updateUI(with: books, emptyView: emptyView)
                isLoadingMoreBooks = false
                dismissLoadingView()
            } catch {
                if let btError = error as? BTError {
                    print(btError.rawValue)
                } else {
                    print(error.localizedDescription)
                }
                isLoadingMoreBooks = false
                dismissLoadingView()
            }
        }
    }
    
    private func resetSearch() {
        self.books.removeAll()
        self.page = 1
        self.moreBooksAvailable = true
    }
    
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        resetSearch()
        self.query = query
        isSearching = true
        getBooks(for: query, page: 1)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resetSearch()
        isSearching = false
        updateUI(with: self.books, emptyView: emptyView)
    }
    
}

// MARK: - UITableViewDelegate

extension SearchViewController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let book = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let destinationViewController = BookDetailsViewController(book: book, mode: .search)
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let contentViewYOffset = scrollView.contentOffset.y
        let contentViewHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if contentViewYOffset >= contentViewHeight - scrollViewHeight {
            guard moreBooksAvailable, !isLoadingMoreBooks, let query else { return }
            page += 1
            getBooks(for: query, page: page)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addAction = UIContextualAction(style: .normal, title: "Add") { [weak self] action, view, complete in
            guard let self else {return }
            guard let bookToAdd = self.dataSource.itemIdentifier(for: indexPath) else { return }
            
            // Add the book in UserDefaults.
            let error = PersistenceManager.update(book: bookToAdd, actionType: .add)
            if let error {
                print(error.localizedDescription)
            }
            complete(true)
        }
        
        addAction.backgroundColor = .systemGreen
        let configuration = UISwipeActionsConfiguration(actions: [addAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
}
