//
//  UIViewController+Presenting.swift
//  BookTracker
//
//  Created by Jack Radford on 11/04/2024.
//

import UIKit

extension UIViewController {
    
    /// Title, message, and actionLabel have defaut, 'generic', values.
    func presentBTAlertOnMainThread(
        title: String? = nil,
        message: String? = nil,
        actionLabel: String? = nil,
        action: (() -> Void)? = nil
    ) {
        let alertViewController = BTAlertViewController(
            alertTitle: title,
            alertMessage: message,
            buttonLabel: actionLabel,
            action: action
        )
        alertViewController.modalPresentationStyle = .overFullScreen
        alertViewController.modalTransitionStyle = .crossDissolve
        DispatchQueue.main.async { self.present(alertViewController, animated: true) }
    }
    
    
    /// Show an alert with the BTError rawValue as the message if the error is a BTError,
    /// else show the default alert
    ///
    /// - Parameter error: An Error (Could be a BTError)
    func presentBTAlertOnMainThread(for error: Error, action: (() -> Void)? = nil) {
        if let btError = error as? BTError {
            presentBTAlertOnMainThread(message: btError.rawValue, action: action)
        } else {
            // Generic error message
            presentBTAlertOnMainThread()
        }
    }
}
