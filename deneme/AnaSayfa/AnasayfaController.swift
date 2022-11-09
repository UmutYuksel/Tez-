//
//  AnasayfaController.swift
//  deneme
//
//  Created by Umut Yüksel on 28.10.2022.
//

import UIKit
import Firebase

class AnasayfaController : UICollectionViewController {
    
    let hucreID = "hucreID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(AnaPaylasimCell.self, forCellWithReuseIdentifier: hucreID)
        navBarDuzenle()
        paylasimlariGetir()
    }
    
    var paylasimlar = [Paylasim]()
    fileprivate func paylasimlariGetir() {
        
        paylasimlar.removeAll()
        guard let gecerliKullaniciID = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("Paylasimlar").document(gecerliKullaniciID)
            .collection("Fotograf_Paylasimlari").order(by: "PaylasimTarihi", descending: false)
            .addSnapshotListener { querySnapshot, hata in
                if let hata = hata {
                    print("Paylaşımlar Getirilirken Hata Oluştu",hata.localizedDescription)
                    return
                }
                querySnapshot?.documentChanges.forEach({ (degisiklik) in
                    if degisiklik.type == .added {
                        let paylasimVerisi = degisiklik.document.data()
                        let paylasim = Paylasim(sozlukVerisi: paylasimVerisi)
                        self.paylasimlar.append(paylasim)
                    }
                })
                self.paylasimlar.reverse()
                self.collectionView.reloadData()
            }
    }
    
    fileprivate func navBarDuzenle() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "food-c.png"))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paylasimlar.count
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let hucre = collectionView.dequeueReusableCell(withReuseIdentifier: hucreID, for: indexPath) as! AnaPaylasimCell
        hucre.paylasim = paylasimlar[indexPath.row]
        hucre.backgroundColor = .red
        return hucre
    }
}

extension AnasayfaController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var yukseklik : CGFloat = 55
        yukseklik += view.frame.width
        yukseklik += 50
        return CGSize(width: view.frame.width, height: yukseklik)
    }
}
