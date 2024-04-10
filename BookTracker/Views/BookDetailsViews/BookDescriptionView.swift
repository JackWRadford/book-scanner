//
//  BookDescriptionView.swift
//  BookTracker
//
//  Created by Jack Radford on 10/04/2024.
//

import UIKit

class BookDescriptionView: UIView {

    private let titleLabelView = BTTitleLabel(weight: .bold)
    private let descriptionLabelView = BTBodyLabel()
    
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
        addSubview(descriptionLabelView)
        titleLabelView.translatesAutoresizingMaskIntoConstraints = false
        titleLabelView.text = "Description"
        
        descriptionLabelView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabelView.text = book.description
        
        NSLayoutConstraint.activate([
            titleLabelView.topAnchor.constraint(equalTo: topAnchor),
            titleLabelView.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabelView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            descriptionLabelView.topAnchor.constraint(equalTo: titleLabelView.bottomAnchor, constant: 8),
            descriptionLabelView.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionLabelView.trailingAnchor.constraint(equalTo: trailingAnchor),
            descriptionLabelView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
