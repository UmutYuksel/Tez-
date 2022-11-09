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
    
    let paylasimHucreID = "paylaşımHücreID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        navigationItem.title = "Kullanıcı Profili"
        kullaniciyiGetir()
        collectionView.register(KullanıcıProfilHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerID")
        collectionView.register(KullaniciPaylasimFotoCell.self, forCellWithReuseIdentifier: paylasimHucreID)
        btnOturumKapatOlustur()
    }
    
    var paylasimlar = [Paylasim]()
    
    fileprivate func paylasimlariGetirFS() {
        
        guard let gecerliKullaniciID = Auth.auth().currentUser?.uid else { return }
        guard let gecerliKullanici = gecerliKullanici else { return }
        Firestore.firestore().collection("Paylasimlar").document(gecerliKullaniciID)
            .collection("Fotograf_Paylasimlari").order(by: "PaylasimTarihi",descending: false)
        .addSnapshotListener{ (QuerySnapshot, hata) in
            
            if let hata = hata {
                print("Fotoğraflar Getirilirken Hata Oluştu",hata)
                return
            }
            QuerySnapshot?.documentChanges.forEach({ (degisiklik) in
                if degisiklik.type == .added {
                    let paylasimVerisi = degisiklik.document.data() // Döküman Verisine Ulaşmayı Sağlar
                   let paylasim = Paylasim(kullanici: gecerliKullanici, sozlukVerisi: paylasimVerisi)
                    self.paylasimlar.append(paylasim)
                }
            })
            // Tüm Paylaşımlar paylasimlar dizisine aktarıldı
            self.paylasimlar.reverse()
            self.collectionView.reloadData()
            
        }
    }
    
    fileprivate func btnOturumKapatOlustur() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings.png")?.withRenderingMode(.alwaysOriginal),style: .plain, target: self ,action: #selector(oturumKapat))
    }
    
    @objc fileprivate func oturumKapat() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionOturumuKapat = UIAlertAction(title: "Oturumu Kapat", style: .destructive) { (_) in
            
            guard let _ = Auth.auth().currentUser?.uid else { return }
            do {
                //Oturum Kapatma
                try Auth.auth().signOut()
                let oturumAcController = OturumAcController()
                let navController = UINavigationController(rootViewController: oturumAcController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            } catch let oturumuKapatmaHatasi {
                print("Oturumu Kapatırken hata oldu",oturumuKapatmaHatasi)
            }
        }
        let actionIptalEt = UIAlertAction(title: "İptal Et", style: .cancel, handler: nil)
        alertController.addAction(actionOturumuKapat)
        alertController.addAction(actionIptalEt)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let genislik = (view.frame.width - 5) / 3
        return CGSize(width: genislik, height: genislik)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paylasimlar.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let paylasimHucre = collectionView.dequeueReusableCell(withReuseIdentifier: paylasimHucreID, for: indexPath) as! KullaniciPaylasimFotoCell
        paylasimHucre.paylasim = paylasimlar[indexPath.row]
        return paylasimHucre
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
            self.paylasimlariGetirFS()
            self.navigationItem.title = self.gecerliKullanici?.kullaniciAdi
            
        }
    }
}

extension KullanıcıProfilController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 200)
    }
    
}
