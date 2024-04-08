//
//  UIView+Constraints.swift
//  BookTracker
//
//  Created by Jack Radford on 08/04/2024.
//

import UIKit

extension UIView {
    
    
    /// Constrains the view to the edges of the given superview.
    /// 
    /// - Parameter superview: The UIView to constrain the view to.
    func constrain(to superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
}
