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
    
    var query: String?
    var books: [Book] = []
    var page = 1
    var moreBooksAvailable = true
    var isLoadingMoreBooks = false
    
    var tableView = UITableView()
    var dataSource: DataSource!
    
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
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.register(BookCollectionViewCell.self, forCellReuseIdentifier: BookCollectionViewCell.reuseID)
        tableView.rowHeight = 80
        tableView.dataSource = self
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
                dismissLoadingView()
            } catch {
                if let btError = error as? BTError {
                    print(btError.rawValue)
                } else {
                    print(error.localizedDescription)
                }
                dismissLoadingView()
            }
        }
    }
    
    private func updateUI(with books: [Book]) {
        if books.count < NetworkManager.pageSize { moreBooksAvailable = false }
        self.books += books
        self.updateData(with: self.books)
    }
    
    // MARK: - Diffable DataSource
    
    private func configureDataSource() {
        dataSource = DataSource(tableView: tableView, cellProvider: { tableView, indexPath, book in
            let cell = tableView.dequeueReusableCell(withIdentifier: BookCollectionViewCell.reuseID, for: indexPath) as! BookCollectionViewCell
            cell.set(book: book)
            return cell
        })
    }
    
    private func updateData(with books: [Book]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(books)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }

}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        getBooks(for: query, page: 1)
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookCollectionViewCell.reuseID) as! BookCollectionViewCell
        let book = books[indexPath.row]
        cell.set(book: book)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = books[indexPath.row]
        
    }
    
}
