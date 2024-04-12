//
//  BTAlertViewController.swift
//  BookTracker
//
//  Created by Jack Radford on 11/04/2024.
//

import UIKit

class BTAlertViewController: UIViewController {
    
    // MARK: - View Properties
    
    private let containerView = BTAlertContainerView()
    private let titleLabelView = BTTitleLabel(textAlignment: .center, fontSize: 16)
    private let messageLabelView = BTBodyLabel(textAlignment: .center)
    private let actionButtonView = BTButton(title: "Okay", config: .borderedProminent())
    
    // MARK: - Properties
    
    var alertTitle: String
    var alertMessage: String
    var buttonLabel: String
    
    // MARK: - Constants
    
    private let padding: CGFloat = 20
    
    // MARK: - Init
    
    init(
        alertTitle: String?,
        alertMessage: String?,
        buttonLabel: String?
    ) {        
        self.alertTitle = alertTitle ?? "Something went wrong"
        self.alertMessage = alertMessage ?? "Please try again later."
        self.buttonLabel = buttonLabel ??  "Okay"
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureContainerView()
        configureTitleLabel()
        configureMessageLabel()
        configureActionButton()
    }
    
    // MARK: - Functions
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
    
    // MARK: - Configuration
    
    private func configureViewController() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
    }
    
    private func configureContainerView() {
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 260),
            containerView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func configureTitleLabel() {
        containerView.addSubview(titleLabelView)
        titleLabelView.text = alertTitle
        
        NSLayoutConstraint.activate([
            titleLabelView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabelView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabelView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding)
        ])
    }
    
    private func configureMessageLabel() {
        containerView.addSubview(messageLabelView)
        messageLabelView.text = alertMessage
        messageLabelView.numberOfLines = 4
        
        NSLayoutConstraint.activate([
            messageLabelView.topAnchor.constraint(equalTo: titleLabelView.bottomAnchor, constant: 12),
            messageLabelView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabelView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
        ])
    }
    
    private func configureActionButton() {
        containerView.addSubview(actionButtonView)
        actionButtonView.setTitle(buttonLabel, for: .normal)
        actionButtonView.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            actionButtonView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButtonView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            actionButtonView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding)
        ])
    }
    
}
