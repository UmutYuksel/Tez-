//
//  NewMessage.swift
//  tez
//
//  Created by Umut Yüksel on 18.12.2022.
//

import UIKit
import Firebase


class NewMessageController : ListeController<TakipCell,Takip>, UICollectionViewDelegateFlowLayout{
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    let navBar = NewMessageNavBar()
    fileprivate let navBarHeight : CGFloat = 100
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 70)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar.btnBack.addTarget(self, action: #selector(btnBackPressed), for: .touchUpInside)
        gorunumuOlustur()
        kullanicilariGetir()
        
    }
    
    fileprivate func gorunumuOlustur() {
        view.addSubview(navBar)
        navBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,boyut: .init(width: 0, height: navBarHeight))
        collectionView.contentInset.top = navBarHeight
        
        let statusBar = UIView(arkaPlanRenk: .white)
        view.addSubview(statusBar)
        statusBar.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        
        collectionView.verticalScrollIndicatorInsets.top = navBarHeight
    }
    
    @objc fileprivate func btnBackPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    var kullanicilar = [Takip]()
    
    
    fileprivate func kullanicilariGetir() {
        
        Firestore.firestore().collection("Kullanicilar").getDocuments { (snapshot, hata) in
            
            if let hata = hata {
                print("Kullanıcılar Getirilirken Hata Meydana Geldi : \(hata.localizedDescription)")
            }
            snapshot?.documentChanges.forEach({ degisiklik in
                if degisiklik.type == .added {
                    let kullanici = Takip(veri: degisiklik.document.data())
                    if kullanici.kullaniciID != Auth.auth().currentUser?.uid {
                        self.kullanicilar.append(kullanici)
                    }
                }
            })
            self.kullanicilar.sort{ (k1, k2) -> Bool in
                return k1.kullaniciAdi.compare(k2.kullaniciAdi) == .orderedAscending
            }
            self.veriler = self.kullanicilar
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 8, left: 22, bottom: 8, right: 22)
    }
}

extension NewMessageController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let eslesme = veriler[indexPath.item]
        let messageController = MessagesController(eslesme: eslesme)
        navigationController?.pushViewController(messageController, animated: true)
    }
}

