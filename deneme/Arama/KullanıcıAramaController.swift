//
//  KullanıcıAramaController.swift
//  deneme
//
//  Created by Umut Yüksel on 21.11.2022.
//

import UIKit
import Firebase
import FirebaseFirestore

class KullanıcıAramaController : UICollectionViewController, UISearchBarDelegate {
    
    lazy var searchBar : UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Kullanıcı Adını Giriniz"
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgbDonustur(red: 230, green: 230, blue: 230)
        sb.delegate = self
        return sb
    }()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filtrelenmisKullanicilar = kullanicilar
        } else {
            self.filtrelenmisKullanicilar = self.kullanicilar.filter({ (kullanici) -> Bool in
                
                return kullanici.kullaniciAdi.contains(searchText)
            })
        }
        self.collectionView.reloadData()
    }
    
    let hucreID = "hucreID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        navigationController?.navigationBar.addSubview(searchBar)
        let navBar = navigationController?.navigationBar
        
        searchBar.anchor(top: navBar?.topAnchor, bottom: navBar?.bottomAnchor, leading: navBar?.leadingAnchor, trailing: navBar?.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 10, paddingRight: -10, width: 0, height: 0)
        
        collectionView.register(KullanıcıAramaCell.self, forCellWithReuseIdentifier: hucreID)
        
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
        KullanicilariGetir()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.isHidden = false
    }
    
    var filtrelenmisKullanicilar = [Kullanici]()
    var kullanicilar = [Kullanici]()
    
    fileprivate func KullanicilariGetir() {
        
        Firestore.firestore().collection("Kullanicilar").getDocuments { (querySnapshot, hata) in
            if let hata = hata {
                print("Kullanıcılar Getirilirken Hata Meydana Geldi : \(hata.localizedDescription)")
            }
                querySnapshot?.documentChanges.forEach({ degisiklik in
                    
                    if degisiklik.type == .added {
                        let kullanici = Kullanici(kullaniciVerisi: degisiklik.document.data())
                        if kullanici.kullaniciID != Auth.auth().currentUser?.uid {
                            self.kullanicilar.append(kullanici)
                        }
                    }
                })
            self.kullanicilar.sort{ (k1, k2) -> Bool in
                return k1.kullaniciAdi.compare(k2.kullaniciAdi) == .orderedAscending
            }
            self.filtrelenmisKullanicilar = self.kullanicilar
            self.collectionView.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filtrelenmisKullanicilar.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: hucreID, for: indexPath) as! KullanıcıAramaCell
        
        cell.kullanici = filtrelenmisKullanicilar[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        let kullanici = filtrelenmisKullanicilar[indexPath.row]
        let kullaniciProfilController = KullanıcıProfilController(collectionViewLayout: UICollectionViewFlowLayout())
        kullaniciProfilController.kullaniciID = kullanici.kullaniciID
        navigationController?.pushViewController(kullaniciProfilController, animated: true)
    }
}

extension KullanıcıAramaController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 70)
    }
}
