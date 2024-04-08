//
//  BookDetailsViewController.swift
//  BookTracker
//
//  Created by Jack Radford on 07/04/2024.
//

import UIKit

class BookDetailsViewController: UIViewController {

    private let thumbnailImageView = BTBookImageView(frame: .zero)
    private let titleLabelView = BTTitleLabel(textAlignment: .center, numberOfLines: 3, weight: .regular)
    private let authorsLabelView = BTSubtitleLabel(textAlignment: .center, numberOfLines: 2)
    
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
        configureThumbnailView()
        configureTitleView()
        configureAuthorsView()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        title = book.title
    }
    
    private func configureThumbnailView() {
        view.addSubview(thumbnailImageView)
        
        if let thumbnail = book.thumbnail {
            thumbnailImageView.getThumbnail(from: thumbnail)
        }
        
        let width: CGFloat = 90
        let height = width * 1.5
        
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            thumbnailImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: height),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: width),
        ])
    }
    
    private func configureTitleView() {
        view.addSubview(titleLabelView)
        
        titleLabelView.text = book.title
        
        let horizontalPadding: CGFloat = 35
        
        NSLayoutConstraint.activate([
            titleLabelView.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 15),
            titleLabelView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            titleLabelView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
        ])
    }
    
    private func configureAuthorsView() {
        view.addSubview(authorsLabelView)
        
        authorsLabelView.text = book.authorsString
        
        let horizontalPadding: CGFloat = 50
        
        NSLayoutConstraint.activate([
            authorsLabelView.topAnchor.constraint(equalTo: titleLabelView.bottomAnchor, constant: 8),
            authorsLabelView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            authorsLabelView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
        ])
    }
    
}
