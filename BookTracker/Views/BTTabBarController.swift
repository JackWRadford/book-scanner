//
//  BTTabBarController.swift
//  BookTracker
//
//  Created by Jack Radford on 05/04/2024.
//

import UIKit

class BTTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        viewControllers = [createSearchNavigationController(), createToReadNavigationController()]
    }
    
    private func createSearchNavigationController() -> UINavigationController {
        let searchViewController = SearchViewController()
        searchViewController.title = "Search"
        searchViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        return UINavigationController(rootViewController: searchViewController)
    }
    
    private func createToReadNavigationController() -> UINavigationController {
        let toReadViewController = ToReadViewController()
        toReadViewController.title = "To Read"
        toReadViewController.tabBarItem = UITabBarItem(title: "To Read", image: UIImage(systemName: "books.vertical"), tag: 1)
        return UINavigationController(rootViewController: toReadViewController)
    }
    
}
