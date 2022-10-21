//
//  AnaTabBarController.swift
//  deneme
//
//  Created by Umut Yüksel on 17.10.2022.
//

import Foundation
import UIKit

class AnaTabBarController : UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        let kullaniciProfilController = KullanıcıProfilController(collectionViewLayout: layout)
        let navController = UINavigationController(rootViewController: kullaniciProfilController)
        navController.tabBarItem.image = UIImage(named: "icons8-user-50.png")
        navController.tabBarItem.selectedImage = UIImage(named: "icons8-user-50-dark.png")
        tabBar.tintColor = .black
        viewControllers = [navController, UIViewController()]
    }
}
