//
//  AnaTabBarController.swift
//  deneme
//
//  Created by Umut Yüksel on 17.10.2022.
//

import Foundation
import UIKit
import Firebase

class AnaTabBarController : UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let oturumAcController = OturumAcController()
               
                let navController = UINavigationController(rootViewController: oturumAcController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
                
            }
            return
        }
        
        let layout = UICollectionViewFlowLayout()
        let kullaniciProfilController = KullanıcıProfilController(collectionViewLayout: layout)
        let navController = UINavigationController(rootViewController: kullaniciProfilController)
        navController.tabBarItem.image = UIImage(named: "icons8-user-50.png")
        navController.tabBarItem.selectedImage = UIImage(named: "icons8-user-50-dark.png")
        tabBar.tintColor = .black
        viewControllers = [navController, UIViewController()]
    }
}
