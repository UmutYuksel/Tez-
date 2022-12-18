//
//  MessageNavBar.swift
//  tez
//
//  Created by Umut Yüksel on 18.12.2022.
//

import UIKit

class MessageNavBar : UIView {
    
    let imgUserProfile = DaireselImageView(genislik: 70, image: UIImage(named: "messages.png"))
    let lblUserName = UILabel(text: "Ysuf123", font: .systemFont(ofSize: 17))
    let btnBack = UIButton(image: UIImage(named: "back-arrow-c.png")!.withRenderingMode(.alwaysOriginal))
    let btnFlag = UIButton(image: UIImage(named: "flag-c.png")!.withRenderingMode(.alwaysOriginal))
    fileprivate let eslesme : Takip
    
    init(eslesme : Takip) {
        self.eslesme = eslesme
        lblUserName.text = eslesme.kullaniciAdi
        imgUserProfile.sd_setImage(with: URL(string: eslesme.profileImageUrl))
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        golgeEkle(opacity: 0.3, yaricap: 10, offset: .init(width: 0, height: 10), renk: .init(white: 0, alpha: 0.2))
        
        let middleSV =
        yatayStackViewOlustur(stackViewOlustur(imgUserProfile,lblUserName,spacing: 10,alignment: .center),alignment: .center)
        
        yatayStackViewOlustur(btnBack,middleSV,btnFlag).withMarging(.init(top: 0, left: 15, bottom: 0, right: 15))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
