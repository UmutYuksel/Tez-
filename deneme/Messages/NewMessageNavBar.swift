//
//  NewMessageNavBar.swift
//  tez
//
//  Created by Umut Yüksel on 18.12.2022.
//

import UIKit

class NewMessageNavBar : UIView {
    
    let btnBack = UIButton(image: UIImage(named: "edge-l.png")!.withRenderingMode(.alwaysOriginal))
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        let imgMessage = UIImageView(image: UIImage(named: "messages-cx60.png")?.withRenderingMode(.alwaysOriginal), contentMode: .scaleAspectFit)
        let lblMessage = UILabel(text: "Yeni Mesaj İçin Alıcı Seçiniz", font: .boldSystemFont(ofSize: 18), textColor: UIColor.orangeTint(), textAlignment: .center)
        
        yatayStackViewOlustur(stackViewOlustur(imgMessage.yukseklikAyarla(45),lblMessage,spacing: 5,alignment: .center),alignment: .center)
        
        golgeEkle(opacity: 0.15, yaricap: 10, offset: .init(width: 0, height: 10), renk: .init(white: 0, alpha: 0.2))
    

        addSubview(btnBack)
        
        btnBack.anchor(top: safeAreaLayoutGuide.topAnchor, bottom: nil, leading: leadingAnchor, trailing: nil,padding: .init(top: 12, left: 12, bottom: 0, right: 0),boyut: .init(width: 35, height: 35))
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
