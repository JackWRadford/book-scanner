//
//  BookDetailsViewController.swift
//  BookTracker
//
//  Created by Jack Radford on 07/04/2024.
//

import UIKit

class BookDetailsViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let thumbnailImageView = BTBookImageView(frame: .zero)
    private let titleLabelView = BTTitleLabel(textAlignment: .center, numberOfLines: 3, weight: .regular)
    private let authorsLabelView = BTSubtitleLabel(textAlignment: .center, numberOfLines: 2)
    
    private let valuesStackView = UIStackView(frame: .zero)
    private var ratingView: BTLabeledDataView {
        BTLabeledDataView(value: book.averageRatingString, label: "Rating")
    }
    private var pageCountView: BTLabeledDataView {
        BTLabeledDataView(value: book.pageCountString, label: "Pages")
    }
    private var publishedDateView: BTLabeledDataView {
        BTLabeledDataView(value: book.publishedDateString, label: "Published")
    }
    
    private let horizontalPadding: CGFloat = 24
    
    var book: Book
    
    init(book: Book) {
        self.book = book
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureScrollAndContentViews()
        configureThumbnailView()
        configureTitleView()
        configureAuthorsView()
        configureValuesStackView()
        
        // Call after other views have been configured.
        updateContentSize()
    }
    
    private func updateContentSize() {
        scrollView.contentSize = contentView.bounds.size
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        title = book.title
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
        
        let width: CGFloat = 90
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
        
        let horizontalPadding: CGFloat = 35
        
        NSLayoutConstraint.activate([
            titleLabelView.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 15),
            titleLabelView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            titleLabelView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
        ])
    }
    
    private func configureAuthorsView() {
        contentView.addSubview(authorsLabelView)
        
        authorsLabelView.text = book.authorsString
        
        let horizontalPadding: CGFloat = self.horizontalPadding + 26
        
        NSLayoutConstraint.activate([
            authorsLabelView.topAnchor.constraint(equalTo: titleLabelView.bottomAnchor, constant: 8),
            authorsLabelView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            authorsLabelView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
        ])
    }
    
    private func configureValuesStackView() {
        contentView.addSubview(valuesStackView)
        valuesStackView.translatesAutoresizingMaskIntoConstraints = false
        
        valuesStackView.axis = .horizontal
        valuesStackView.distribution = .fillEqually

        valuesStackView.addArrangedSubview(ratingView)
        valuesStackView.addArrangedSubview(pageCountView)
        valuesStackView.addArrangedSubview(publishedDateView)
        
        NSLayoutConstraint.activate([
            valuesStackView.topAnchor.constraint(equalTo: authorsLabelView.bottomAnchor, constant: 40),
            valuesStackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            valuesStackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
            // constrain to the bottom of the contentView (in the scrollView)
            valuesStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
}
