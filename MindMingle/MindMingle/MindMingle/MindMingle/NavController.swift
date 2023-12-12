//
//  NavController.swift
//  MindMingle
//
//  Created by MindMingle on 10/12/2023.
//


import UIKit

class NavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide the navigation bar globally for all view controllers in this navigation controller
        self.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Adjust content insets globally for all view controllers in this navigation controller
        let navBarHeight = self.navigationBar.frame.height
        self.viewControllers.forEach { viewController in
            viewController.additionalSafeAreaInsets = UIEdgeInsets(top: -navBarHeight, left: 0, bottom: 0, right: 0)
        }
    }
}


