//
//  BTSubtitleLabel.swift
//  BookTracker
//
//  Created by Jack Radford on 08/04/2024.
//

import UIKit

class BTSubtitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(
        textAlignment: NSTextAlignment = .left,
        fontSize: CGFloat = 12,
        numberOfLines: Int = 1,
        weight: UIFont.Weight = .regular,
        color: UIColor = .secondaryLabel
    ) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        self.numberOfLines = numberOfLines
        self.textColor = color
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        lineBreakMode = .byTruncatingTail
    }
    
}
