//
//  BTButton.swift
//  BookTracker
//
//  Created by Jack Radford on 10/04/2024.
//

import UIKit

class BTButton: UIButton {
    
    private let title: String
    private let config: Configuration
    
    init(title: String, config: Configuration = .borderedProminent()) {
        self.title = title
        self.config = config
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(title, for: .normal)
        configuration = config
    }
}
