//
//  BTAlertContainerView.swift
//  BookTracker
//
//  Created by Jack Radford on 11/04/2024.
//

import UIKit

class BTAlertContainerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 16
    }
    
}
