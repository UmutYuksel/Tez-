//
//  KullanıcıProfilHeader.swift
//  deneme
//
//  Created by Umut Yüksel on 17.10.2022.
//

import Foundation
import UIKit
import Firebase

class KullanıcıProfilHeader : UICollectionViewCell {
    
    var gecerliKullanici : Kullanici? {
        
        didSet{
            guard let url = URL(string: gecerliKullanici?.profilGoruntuURL ?? "") else { return }
            
        }
    }
    
    let imgProfilGoruntu : UIImageView = {
        
        let img = UIImageView()
        img.backgroundColor = .yellow
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        addSubview(imgProfilGoruntu)
        let goruntuBoyut : CGFloat = 90
        imgProfilGoruntu.anchor(top: topAnchor, bottom: nil, leading: self.leadingAnchor, trailing: nil, paddingTop: 15, paddingBottom: 0, paddingLeft: 15, paddingRight: 0, width: goruntuBoyut, height: goruntuBoyut)
        imgProfilGoruntu.layer.cornerRadius = goruntuBoyut / 2
        imgProfilGoruntu.clipsToBounds = true
        profilFotoYukle()
    }
    
    fileprivate func profilFotoYukle() {
        
        guard let gecerliKullaniciID = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("Kullanicilar").document(gecerliKullaniciID).getDocument { (snapshot, hata) in
            
            if let hata = hata {
                print("Kullanıcı Bilgisi Getirilemedi",hata)
                return
            }
            
            guard let kullaniciVerisi = snapshot?.data() else { return }
            guard let profilGoruntuURL = kullaniciVerisi["ProfilGoruntuUrl"] as? String else { return }
            guard let url = URL(string: profilGoruntuURL) else { return }
            
            URLSession.shared.dataTask(with: url) { (data, response, hata) in
                
                if let hata = hata {
                    print("Profil Fotoğrafı İndirelemedi",hata)
                    return
                }
                
                print(data)
                guard let data = data else { return }
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.imgProfilGoruntu.image = image
                }
            }.resume()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
