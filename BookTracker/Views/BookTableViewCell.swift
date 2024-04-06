//
//  BookTableViewCell.swift
//  BookTracker
//
//  Created by Jack Radford on 05/04/2024.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    static let reuseID = "BookCell"
    
    let thumbnailImageView = BTBookImageView(frame: .zero)
    let titleLabel = UILabel()
    let authorsLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(book: Book) {
        guard let thumbnailURL = book.thumbnail else { return }
        thumbnailImageView.getThumbnail(from: thumbnailURL)
        titleLabel.text = book.title
        authorsLabel.text = book.authorsString
    }
    
    private func configure() {
        addSubview(thumbnailImageView)
        addSubview(titleLabel)
        addSubview(authorsLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        authorsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        authorsLabel.textColor = .secondaryLabel
        authorsLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        accessoryType = .disclosureIndicator
        
        let horizontalPadding: CGFloat = 14
        let width: CGFloat = 45
        let height = width * 1.5
        
        NSLayoutConstraint.activate([
            thumbnailImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: height),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: width),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
            
            authorsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            authorsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            authorsLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }
}
