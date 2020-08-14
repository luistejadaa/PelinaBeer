//
//  RootTabController.swift
//  PelinaBeer
//
//  Created by Intellisys on 8/13/20.
//  Copyright © 2020 Luis Tejada. All rights reserved.
//

import UIKit

class RootTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewControllers =
        [
            UINavigationController(rootViewController: MainViewController()),
            UINavigationController(rootViewController: FavoritesViewController())
        ]
        
        let mainItem = tabBar.items![0]
        let favoriteItem = tabBar.items![1]
        
        mainItem.image = #imageLiteral(resourceName: "main_icon")
        mainItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        favoriteItem.image = #imageLiteral(resourceName: "favorites_icon")
        favoriteItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        tabBar.tintColor = .mainColor
        tabBar.unselectedItemTintColor = .gray
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
