//
//  BTBookImageView.swift
//  BookTracker
//
//  Created by Jack Radford on 05/04/2024.
//

import UIKit

class BTBookImageView: UIImageView {

    let cache = NetworkManager.shared.cache
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getThumbnail(from urlString: String) {
        Task {
            image = await NetworkManager.shared.getThumbnail(from: urlString)
        }
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 8
        clipsToBounds = true
        backgroundColor = .secondarySystemBackground
        contentMode = .scaleAspectFit
    }
    
}
