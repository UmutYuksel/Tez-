//
//  KullanıcıProfilController.swift
//  deneme
//
//  Created by Umut Yüksel on 17.10.2022.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore

class KullanıcıProfilController : UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        kullaniciyiGetir()
        collectionView.register(KullanıcıProfilHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerID")
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath) as! KullanıcıProfilHeader
        header.gecerliKullanici = gecerliKullanici
        
        
        return header
    }
    var gecerliKullanici : Kullanici?
    fileprivate func kullaniciyiGetir() {
        
        guard let gecerliKullaniciID = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("Kullanicilar").document(gecerliKullaniciID).getDocument { (snapshot , hata ) in
            
            if let hata  = hata {
                print("Kullanıcı Bilgileri Getirilemedi !!!",hata)
                return
            }
            
            guard let kullaniciVerisi = snapshot?.data() else { return }
            self.gecerliKullanici = Kullanici(kullaniciVerisi: kullaniciVerisi)
            self.collectionView.reloadData()
            self.navigationItem.title = self.gecerliKullanici?.kullaniciAdi
            
        }
    }
}



extension KullanıcıProfilController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 200)
    }
    
}
