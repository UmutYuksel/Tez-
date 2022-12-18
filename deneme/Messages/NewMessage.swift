//
//  NewMessage.swift
//  tez
//
//  Created by Umut Yüksel on 18.12.2022.
//

import UIKit
import Firebase

struct Takip {
    
    let kullaniciAdi : String
    let profileImageUrl : String
    let kullaniciID : String
    
    init(veri: [String : Any]) {
        self.kullaniciAdi = veri["KullaniciAdi "] as? String ?? ""
        self.profileImageUrl = veri["ProfilGoruntuUrl"] as? String ?? ""
        self.kullaniciID = veri["KullaniciID"] as? String ?? ""
    }
}

class TakipCell : ListeCell<Takip> {
    
    let imgProfile = UIImageView(image: UIImage(named: "messages.png"),contentMode: .scaleToFill)
    let lblKullaniciAdi = UILabel(text: "Sefa123", font: .systemFont(ofSize: 15, weight: .bold), textColor: .black, textAlignment: .center, numberofLines: 2)
    
    override var veri: Takip!   {
        didSet {
            lblKullaniciAdi.text = veri.kullaniciAdi
            imgProfile.sd_setImage(with: URL(string: veri.profileImageUrl))
        }
    }
    override func viewOlustur() {
        super.viewOlustur()
        
        imgProfile.clipsToBounds = true
        imgProfile.boyutlandir(.init(width: 80, height: 80))
        imgProfile.layer.cornerRadius = 40
        stackViewOlustur(stackViewOlustur(imgProfile,alignment: .center),lblKullaniciAdi)
    }
}
class NewMessage : ListeController<TakipCell,Takip>, UICollectionViewDelegateFlowLayout{
    
    let navBar = NewMessageNavBar()
    fileprivate let navBarHeight : CGFloat = 100
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 125, height: 145)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar.btnBack.addTarget(self, action: #selector(btnBackPressed), for: .touchUpInside)
        collectionView.backgroundColor = .white
        view.addSubview(navBar)
        
        navBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,boyut: .init(width: 0, height: navBarHeight))
        collectionView.contentInset.top = navBarHeight
        kullanicilariGetir()
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
                    let kullanici = degisiklik.document.data()
                    self.kullanicilar.append(.init(veri: kullanici))
                    
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
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
}

extension NewMessage {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let eslesme = veriler[indexPath.item]
        let newMessageController = MessagesController(eslesme: eslesme)
        navigationController?.pushViewController(newMessageController, animated: true)
    }
}

