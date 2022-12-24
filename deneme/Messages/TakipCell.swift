//
//  TakipCell.swift
//  tez
//
//  Created by Umut Yüksel on 20.12.2022.
//

import Foundation
import UIKit

class TakipCell : ListeCell<Takip> {
    
    let imgProfile = UIImageView(image: UIImage(named: "messages.png"),contentMode: .scaleToFill)
    let lblKullaniciAdi = UILabel(text: "Sefa123", font: .boldSystemFont(ofSize: 19))
    let lblUserName = UILabel(text: "", font: .systemFont(ofSize: 12), textColor: .lightGray)
    
    
    override var veri: Takip!   {
        didSet {
            lblKullaniciAdi.text = veri.kullaniciAdi
            lblUserName.text = veri.kullaniciAdi
            imgProfile.sd_setImage(with: URL(string: veri.profileImageUrl))
        }
    }
    override func viewOlustur() {
        super.viewOlustur()
        
        imgProfile.clipsToBounds = true
        imgProfile.boyutlandir(.init(width: 60, height: 60))
        imgProfile.layer.cornerRadius = 30
        
        
        yatayStackViewOlustur(imgProfile,(stackViewOlustur(lblKullaniciAdi,lblUserName)),spacing: 20,alignment: .center)
            .padLeft(10).padRight(10)
        
        ayracEkle(leadingAnchor: lblKullaniciAdi.leadingAnchor)
        
        
    }
}
