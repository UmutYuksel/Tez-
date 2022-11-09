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
        self.delegate = self
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let oturumAcController = OturumAcController()
                
                let navController = UINavigationController(rootViewController: oturumAcController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
                
            }
            return
        }
        
        gorunumuOlustur()
        
    }
    
    func gorunumuOlustur() {
        
        let anaNavController = navControllerOlustur(rootViewController: AnasayfaController(collectionViewLayout: UICollectionViewFlowLayout()))
        let araNavController = araControllerOlustur()
        let ekleNavController = ekleControllerOlustur()
        let likeNavController = likeControllerOlustur()
        
        
        
        let layout = UICollectionViewFlowLayout()
        let kullaniciProfilController = KullanıcıProfilController(collectionViewLayout: layout)
        let kullaniciProfilNavController = UINavigationController(rootViewController: kullaniciProfilController)
        kullaniciProfilNavController.tabBarItem.image = UIImage(named: "user.png")
        kullaniciProfilNavController.tabBarItem.selectedImage = UIImage(named: "user-selected.png")
        tabBar.tintColor = .red
        viewControllers = [anaNavController,araNavController,ekleNavController,likeNavController,kullaniciProfilNavController]
        
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
    fileprivate func araControllerOlustur()-> UINavigationController {
        let rootController = UIViewController()
        let navController = UINavigationController(rootViewController: rootController)
        navController.tabBarItem.image = UIImage(named: "search.png")
        navController.tabBarItem.selectedImage = UIImage(named: "search-selected.png")
        return navController
    }
    fileprivate func ekleControllerOlustur()-> UINavigationController {
        let rootController = UIViewController()
        let navController = UINavigationController(rootViewController: rootController)
        navController.tabBarItem.image = UIImage(named: "add.png")
        return navController
    }
    fileprivate func likeControllerOlustur()-> UINavigationController {
        let rootController = UIViewController()
        let navController = UINavigationController(rootViewController: rootController)
        navController.tabBarItem.image = UIImage(named: "heart.png")
        navController.tabBarItem.selectedImage = UIImage(named: "heart-selected.png")
        return navController
    }
}

extension AnaTabBarController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let index = viewControllers?.firstIndex(of: viewController) else { return true}
        if index == 2 {
            
            let layout = UICollectionViewFlowLayout()
            let fotografSeciciController = FotografSeciciController(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: fotografSeciciController)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true, completion: nil)
            return false
        }
        return true
    }
}
