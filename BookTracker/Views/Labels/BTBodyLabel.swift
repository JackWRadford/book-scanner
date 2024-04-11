//
//  BTBodyLabel.swift
//  BookTracker
//
//  Created by Jack Radford on 08/04/2024.
//

import UIKit

class BTBodyLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment = .left, color: UIColor = .label) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.textColor = color
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontForContentSizeCategory = true
        lineBreakMode = .byWordWrapping
        numberOfLines = 0
    }
    
}
