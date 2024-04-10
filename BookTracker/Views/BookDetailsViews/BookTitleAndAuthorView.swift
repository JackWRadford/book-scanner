//
//  BookTitleAndAuthorView.swift
//  BookTracker
//
//  Created by Jack Radford on 10/04/2024.
//

import UIKit

class BookTitleAndAuthorView: UIView {

    private let titleLabelView = BTTitleLabel(textAlignment: .center, numberOfLines: 3, weight: .bold)
    private let authorsLabelView = BTSubtitleLabel(textAlignment: .center, numberOfLines: 2)
    
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
        addSubview(titleLabelView)
        addSubview(authorsLabelView)
        
        titleLabelView.text = book.title
        authorsLabelView.text = book.authorsString
        
        NSLayoutConstraint.activate([
            titleLabelView.topAnchor.constraint(equalTo: topAnchor),
            titleLabelView.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabelView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            authorsLabelView.topAnchor.constraint(equalTo: titleLabelView.bottomAnchor, constant: 5),
            authorsLabelView.leadingAnchor.constraint(equalTo: leadingAnchor),
            authorsLabelView.trailingAnchor.constraint(equalTo: trailingAnchor),
            authorsLabelView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
