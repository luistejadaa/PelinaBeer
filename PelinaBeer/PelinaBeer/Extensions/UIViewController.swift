//
//  UIViewController.swift
//  PelinaBeer
//
//  Created by Intellisys on 8/13/20.
//  Copyright © 2020 Luis Tejada. All rights reserved.
//

import UIKit.UIViewController

extension UIViewController {
    
    internal func configureLargueTitleWith(text: String!) {
        
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController?.searchBar.placeholder = "Buscar película"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .mainColor
        navigationItem.title = text
        let attr = [NSAttributedString.Key.foregroundColor : UIColor.mainColor]
        navigationController?.navigationBar.titleTextAttributes = attr
        navigationController?.navigationBar.largeTitleTextAttributes = attr
        navigationItem.rightBarButtonItems = [UIBarButtonItem]()
    }
    
    func addIRightItem(image: UIImage, action : Selector!) {
        
        navigationItem.rightBarButtonItems?.append(UIBarButtonItem(image: image, style: .done, target: self, action: action))
    }
}
