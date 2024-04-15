//
//  BookDetailsViewController.swift
//  BookTracker
//
//  Created by Jack Radford on 07/04/2024.
//

import UIKit

enum BookDetailsMode {
    case search, toRead
}

class BookDetailsViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    
    private var thumbnailView: BookDetailsThumbnailView!
    private var titleAndAuthorView: BookTitleAndAuthorView!
    private var bookValuesView: BookValuesView!
    private var descriptionView: BookDescriptionView!
    private let publisherLabelView = BTSubtitleLabel(textAlignment: .center)
    
    var mode: BookDetailsMode
    var book: Book
    
    // MARK: - Init
    
    init(book: Book, mode: BookDetailsMode) {
        self.book = book
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureScrollAndContentViews()
        configureViews()
        
        // Call after other views have been configured to set the ScrollView size.
        updateContentSize()
        
        scrollView.delegate = self
    }
    
    // MARK: - Functions
    
    @objc private func addBook() { performBookAction(for: .add) }
    
    @objc private func removeBook() { performBookAction(for: .delete) }
    
    
    /// Either adds or removes the book and presents an error alert if needed.
    private func performBookAction(for actionType: PersistenceAction) {
        do {
            try PersistenceManager.update(book: book, actionType: actionType)
            navigationController?.popViewController(animated: true)
        } catch {
            presentBTAlertOnMainThread(for: error)
        }
    }
    
    private func updateContentSize() {
        scrollView.contentSize = contentView.bounds.size
    }
    
    // MARK: - Configuration
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        switch mode {
        case .search:
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addBook))
        case .toRead:
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Remove", style: .done, target: self, action: #selector(removeBook))
        }
    }
    
    private func configureScrollAndContentViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.constrain(to: view)
        contentView.constrain(to: scrollView)
        
        contentView.axis = .vertical
        contentView.spacing = 24
        contentView.alignment = .fill
        
        let padding: CGFloat = 20
        contentView.layoutMargins = UIEdgeInsets(allSides: padding)
        contentView.isLayoutMarginsRelativeArrangement = true
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func configureViews() {
        thumbnailView = BookDetailsThumbnailView(book: book)
        titleAndAuthorView = BookTitleAndAuthorView(book: book)
        bookValuesView = BookValuesView(book: book)
        descriptionView = BookDescriptionView(book: book)
        publisherLabelView.text = "Published by \(book.publisherString)"
        
        contentView.addArrangedSubviews(
            thumbnailView,
            titleAndAuthorView,
            bookValuesView,
            descriptionView,
            publisherLabelView
        )
    }
}

// MARK: - UIScrollViewDelegate

extension BookDetailsViewController: UIScrollViewDelegate {
    /// Show the book title as the ViewController navigation bar title if the title view is scrolled out of view.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let minY = titleAndAuthorView.convert(CGPoint.zero, to: view).y
        let titleVisible = minY >= view.safeAreaInsets.top
        title = titleVisible ? nil : book.title
    }
    
}
