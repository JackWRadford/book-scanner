//
//  BTLabeledDataView.swift
//  BookTracker
//
//  Created by Jack Radford on 08/04/2024.
//

import UIKit

class BTLabeledDataView: UIView {

    private let valueView = BTTitleLabel(textAlignment: .center, weight: .bold)
    private let labelView = BTSubtitleLabel(textAlignment: .center, color: .label)
    
    var value: String
    
    var label: String
    
    init(value: String, label: String) {
        self.value = value
        self.label = label
        
        super.init(frame: .zero)
        
        configureValueView()
        configureLabelView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureValueView() {
        addSubview(valueView)
        
        valueView.text = value
        
        NSLayoutConstraint.activate([
            valueView.topAnchor.constraint(equalTo: topAnchor),
            valueView.leadingAnchor.constraint(equalTo: leadingAnchor),
            valueView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func configureLabelView() {
        addSubview(labelView)
        
        labelView.text = label
        
        NSLayoutConstraint.activate([
            labelView.topAnchor.constraint(equalTo: valueView.bottomAnchor, constant: 3),
            labelView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}
