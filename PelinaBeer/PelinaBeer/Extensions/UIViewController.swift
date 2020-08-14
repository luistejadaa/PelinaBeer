//
//  UIViewController.swift
//  PelinaBeer
//
//  Created by Intellisys on 8/13/20.
//  Copyright © 2020 Luis Tejada. All rights reserved.
//

import Foundation
import UIKit.UIViewController

extension UIViewController {
    
    internal func configureLargueTitleWith(text: String!) {
        
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController?.searchBar.placeholder = "Buscar película"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = text
    }
}
