//
//  BookValuesView.swift
//  BookTracker
//
//  Created by Jack Radford on 10/04/2024.
//

import UIKit

class BookValuesView: UIStackView {
    
    private var ratingView: BTLabeledDataView {
        BTLabeledDataView(value: book.averageRatingString, label: "Rating")
    }
    private var pageCountView: BTLabeledDataView {
        BTLabeledDataView(value: book.pageCountString, label: "Pages")
    }
    private var publishedDateView: BTLabeledDataView {
        BTLabeledDataView(value: book.publishedDateString, label: "Published")
    }

    var book: Book
    
    init(book: Book) {
        self.book = book
        super.init(frame: .zero)        
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal
        distribution = .fillEqually
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 16
        
        let padding: CGFloat = 20
        layoutMargins = UIEdgeInsets(allSides: padding)
        isLayoutMarginsRelativeArrangement = true
        
        addArrangedSubviews(ratingView, publishedDateView, pageCountView)
    }

}
