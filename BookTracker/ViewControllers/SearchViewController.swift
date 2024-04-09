//
//  SearchViewController.swift
//  BookTracker
//
//  Created by Jack Radford on 05/04/2024.
//

import UIKit

class SearchViewController: GFDataLoadingViewController {
    typealias DataSource = UITableViewDiffableDataSource<Section, Book>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Book>
    
    enum Section {
        case main
    }
    
    private var query: String?
    private var books: [Book] = []
    private var page = 1
    private var moreBooksAvailable = true
    private var isLoadingMoreBooks = false
    
    private var tableView = UITableView()
    private var dataSource: DataSource!
    
    private var emptyStateView: BTEmptyStateView?
    
    // MARK: - UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureDataSource()
        configureSearchController()
    }
    
    // MARK: - Configuration
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureDataSource() {
        dataSource = DataSource(tableView: tableView, cellProvider: { tableView, indexPath, book in
            let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.reuseID, for: indexPath) as! BookTableViewCell
            cell.set(book: book)
            return cell
        })
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.frame = view.bounds
        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.reuseID)
        tableView.rowHeight = 80
    }
    
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
                let books = try await NetworkManager.shared.getBooks(for: query, page: page)
                updateUI(with: books)
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
    
    private func updateUI(with books: [Book]) {
        if books.count < NetworkManager.pageSize { moreBooksAvailable = false }
        self.books += books
        self.updateData(with: self.books)
    }
    
    private func updateData(with books: [Book]) {
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
            self.dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    private func showEmptyStateView() {
        emptyStateView = BTEmptyStateView(
            systemName: "magnifyingglass",
            title: "No Books Found",
            subTitle: "Check spelling or try a new search."
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

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        self.books.removeAll()
        self.query = query
        self.page = 1
        self.moreBooksAvailable = true
        getBooks(for: query, page: 1)
    }
    
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    
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
    
}
