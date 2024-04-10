//
//  BookDetailsThumbnailView.swift
//  BookTracker
//
//  Created by Jack Radford on 10/04/2024.
//

import UIKit

class BookDetailsThumbnailView: UIView {
    
    private let thumbnailImageView = BTBookImageView(frame: .zero)
    
    var book: Book
    
    init(book: Book) {
        self.book = book
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(thumbnailImageView)
        
        if let thumbnail = book.thumbnail {
            thumbnailImageView.getThumbnail(from: thumbnail)
        }
        
        let width: CGFloat = 160
        let height = width * 1.5
        
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: topAnchor),
            thumbnailImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: height),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: width),
            thumbnailImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
}
