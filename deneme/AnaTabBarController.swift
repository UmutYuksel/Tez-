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
        guard let user = Auth.auth().currentUser else { return }
        switch user.isEmailVerified {
        case true:
            gorunumuOlustur()
        case false:
            DispatchQueue.main.async {
                let oturumAcController = OturumAcController()
                
                let navController = UINavigationController(rootViewController: oturumAcController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
                
            }
            return
        }
    }
    
    func gorunumuOlustur() {
        
        let anaNavController = navControllerOlustur(rootViewController: AnasayfaController(collectionViewLayout: UICollectionViewFlowLayout()))
        let araNavController = araControllerOlustur(rootViewController: KullanıcıAramaController(collectionViewLayout: UICollectionViewFlowLayout()))
        let layout = UICollectionViewFlowLayout()
        let kullaniciProfilController = KullanıcıProfilController(collectionViewLayout: layout)
        
        let kullaniciProfilNavController = UINavigationController(rootViewController: kullaniciProfilController)
        kullaniciProfilNavController.tabBarItem.image = UIImage(named: "user.png")
        kullaniciProfilNavController.tabBarItem.selectedImage = UIImage(named: "user-selected.png")
        tabBar.tintColor = UIColor.orangeTint()
        viewControllers = [anaNavController,araNavController,kullaniciProfilNavController]
        
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -5, right: 0)
        }
    }
    
    fileprivate func navControllerOlustur(rootViewController: UIViewController = UIViewController())-> UINavigationController {
        let rootController = rootViewController
        let navController = UINavigationController(rootViewController: rootController)
        navController.tabBarItem.image = UIImage(named: "home.png")
        navController.tabBarItem.selectedImage = UIImage(named: "home-selected.png")
        return navController
    }
    fileprivate func araControllerOlustur(rootViewController: UIViewController = UIViewController())-> UINavigationController {
        let rootController = rootViewController
        let navController = UINavigationController(rootViewController: rootController)
        navController.tabBarItem.image = UIImage(named: "search.png")
        navController.tabBarItem.selectedImage = UIImage(named: "search-selected.png")
        return navController
    }
}
