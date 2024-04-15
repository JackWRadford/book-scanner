//
//  UIEdgeInsets+Ext.swift
//  BookTracker
//
//  Created by Jack Radford on 10/04/2024.
//

import UIKit

extension UIEdgeInsets {
    
    /// Creates UIEdgeInsets with the same padding on top, left, bottom, and right.
    /// 
    /// - Parameter value: A CGFloat representing the amount of padding.
    init(allSides value: CGFloat) {
        self.init(top: value, left: value, bottom: value, right: value)
    }    
    
    /// Creates UIEdgeInsets with top and bottom set to vertical and left and right to horizontal.
    ///
    /// - Parameters:
    ///   - vertical: A CGFloat for the vertical padding.
    ///   - horizontal: A CGFloat for the horizontal padding.
    init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
}
