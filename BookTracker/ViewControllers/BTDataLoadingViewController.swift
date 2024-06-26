//
//  BTDataLoadingViewController.swift
//  BookTracker
//
//  Created by Jack Radford on 05/04/2024.
//

import UIKit


/// Implements presenting and dismissing a loading indicator view.
class BTDataLoadingViewController: UIViewController {

    private var containerView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        guard let containerView else { return }
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        UIView.animate(withDuration: 0.25) { self.containerView?.alpha = 0.8 }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    func dismissLoadingView() {
        DispatchQueue.main.async {
            self.containerView?.removeFromSuperview()
            self.containerView = nil
        }
    }

}
