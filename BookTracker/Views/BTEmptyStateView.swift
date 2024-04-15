//
//  BTEmptyStateView.swift
//  BookTracker
//
//  Created by Jack Radford on 06/04/2024.
//

import UIKit

class BTEmptyStateView: UIView {

    private var imageView = UIImageView()
    private var titleLabel = UILabel()
    private var subTitleLabel = UILabel()
    
    private(set) var systemName: String
    private(set) var title: String
    private(set) var subTitle: String
    
    init(systemName: String, title: String, subTitle: String) {
        self.systemName = systemName
        self.title = title
        self.subTitle = subTitle
        
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        configureImageView()
        configureTitleView()
        configureSubTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTitleView() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        titleLabel.text = title
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 14),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureSubTitle() {
        addSubview(subTitleLabel)
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        subTitleLabel.textColor = .secondaryLabel
        subTitleLabel.text = subTitle
        
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subTitleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureImageView() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.tintColor = .secondaryLabel
        imageView.image = UIImage(systemName: systemName)
        
        let width: CGFloat = 70
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: width),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
}
