//
//  UIViewController+Presenting.swift
//  BookTracker
//
//  Created by Jack Radford on 11/04/2024.
//

import UIKit

extension UIViewController {
    
    
    /// Title, message, and actionLabel have defaut, 'generic', values.
    func presentBTAlertOnMainThread(title: String? = nil, message: String? = nil, actionLabel: String? = nil) {
        let alertViewController = BTAlertViewController(alertTitle: title, alertMessage: message, buttonLabel: actionLabel)
        alertViewController.modalPresentationStyle = .overFullScreen
        alertViewController.modalTransitionStyle = .crossDissolve
        DispatchQueue.main.async { self.present(alertViewController, animated: true) }
    }
}
