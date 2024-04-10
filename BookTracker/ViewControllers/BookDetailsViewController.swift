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
    private let contentView = UIView()
    
    private let thumbnailImageView = BTBookImageView(frame: .zero)
    private let titleLabelView = BTTitleLabel(textAlignment: .center, numberOfLines: 3, weight: .regular)
    private let authorsLabelView = BTSubtitleLabel(textAlignment: .center, numberOfLines: 2)
    private var bookValuesView: BookValuesView!
    private let descriptionLabelView = BTBodyLabel()
    private let publisherLabelView = BTSubtitleLabel(textAlignment: .left)
    
    let horizontalPadding: CGFloat = 25
    
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
        configureThumbnailView()
        configureTitleView()
        configureAuthorsView()
        configureValuesStackView()
        configureDescriptionLabelView()
        configurePublisherLabelView()
        
        // Call after other views have been configured.
        updateContentSize()
        
        scrollView.delegate = self
    }
    
    // MARK: - Functions
    
    @objc private func addBook() {
        let error = PersistenceManager.update(book: book, actionType: .add)
        handlePersistenceUpdate(error)
    }
    
    @objc private func removeBook() {
        let error = PersistenceManager.update(book: book, actionType: .delete)
        handlePersistenceUpdate(error)
    }
    
    private func handlePersistenceUpdate(_ error: BTError?) {
        if let error {
            print(error.rawValue)
        } else {
            navigationController?.popViewController(animated: true)
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
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func configureThumbnailView() {
        contentView.addSubview(thumbnailImageView)
        
        if let thumbnail = book.thumbnail {
            thumbnailImageView.getThumbnail(from: thumbnail)
        }
        
        let width: CGFloat = 140
        let height = width * 1.5
        
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 32),
            thumbnailImageView.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: height),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: width),
        ])
    }
    
    private func configureTitleView() {
        contentView.addSubview(titleLabelView)
        
        titleLabelView.text = book.title
        
        let horizontalPadding: CGFloat = horizontalPadding + 10
        
        NSLayoutConstraint.activate([
            titleLabelView.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 15),
            titleLabelView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            titleLabelView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
        ])
    }
    
    private func configureAuthorsView() {
        contentView.addSubview(authorsLabelView)
        
        authorsLabelView.text = book.authorsString
        
        let horizontalPadding: CGFloat = 50
        
        NSLayoutConstraint.activate([
            authorsLabelView.topAnchor.constraint(equalTo: titleLabelView.bottomAnchor, constant: 8),
            authorsLabelView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            authorsLabelView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
        ])
    }
    
    private func configureValuesStackView() {
        bookValuesView = BookValuesView(book: book)
        contentView.addSubview(bookValuesView)
        
        let horizontalPadding: CGFloat = horizontalPadding + 25
        
        NSLayoutConstraint.activate([
            bookValuesView.topAnchor.constraint(equalTo: authorsLabelView.bottomAnchor, constant: 40),
            bookValuesView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            bookValuesView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding)
        ])
    }
    
    private func configureDescriptionLabelView() {
        contentView.addSubview(descriptionLabelView)
        descriptionLabelView.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabelView.text = book.description
        
        NSLayoutConstraint.activate([
            descriptionLabelView.topAnchor.constraint(equalTo: bookValuesView.bottomAnchor, constant: 40),
            descriptionLabelView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            descriptionLabelView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
        ])
    }
    
    private func configurePublisherLabelView() {
        view.addSubview(publisherLabelView)
        publisherLabelView.translatesAutoresizingMaskIntoConstraints = false
        
        publisherLabelView.text = "Published by \(book.publisher ?? "Unknown")"
        
        NSLayoutConstraint.activate([
            publisherLabelView.topAnchor.constraint(equalTo: descriptionLabelView.bottomAnchor, constant: 20),
            publisherLabelView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            publisherLabelView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
            // constrain to the bottom of the contentView (in the scrollView)
            publisherLabelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50)
        ])
    }
    
}

// MARK: - UIScrollViewDelegate

extension BookDetailsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let minY = titleLabelView.convert(CGPoint.zero, to: view).y
        let titleVisible = minY >= view.safeAreaInsets.top
        title = titleVisible ? nil : book.title
    }
    
}
