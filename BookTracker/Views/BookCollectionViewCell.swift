//
//  BookCollectionViewCell.swift
//  BookTracker
//
//  Created by Jack Radford on 05/04/2024.
//

import UIKit

class BookCollectionViewCell: UITableViewCell {
    static let reuseID = "BookCell"
    
    let thumbnailImageView = BTBookImageView(frame: .zero)
    let titleLabel = UILabel()
    
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
    }
    
    private func configure() {
        addSubview(thumbnailImageView)
        addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        accessoryType = .disclosureIndicator
        
        let verticalPadding: CGFloat = 8
        let horizontalPadding: CGFloat = 14
        let width: CGFloat = 45
        let height = width * 1.5
        
        NSLayoutConstraint.activate([
            thumbnailImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: height),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: width),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalPadding),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
