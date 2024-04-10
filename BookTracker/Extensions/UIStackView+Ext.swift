//
//  UIStackView+Ext.swift
//  BookTracker
//
//  Created by Jack Radford on 10/04/2024.
//

import UIKit

extension UIStackView {
        
    /// Adds each subview to the end of the arranged subviews array.
    ///
    /// - Parameter subviews: The UIViews to add.
    func addArrangedSubviews(_ subviews: UIView...) {
        for subview in subviews {
            addArrangedSubviews(subview)
        }
    }
}
