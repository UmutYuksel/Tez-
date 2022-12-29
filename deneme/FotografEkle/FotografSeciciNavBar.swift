//
//  FotografSeciciNavBar.swift
//  tez
//
//  Created by Umut Yüksel on 26.12.2022.
//

import Foundation
import UIKit

class FotografSeciciNavBar : UIView {
    
    let btnBack = UIButton(image: UIImage(named: "cancel-filled.png")!.withRenderingMode(.alwaysOriginal))
    let btnShare = UIButton(baslik: "İleri", baslikRenk: UIColor.orangeTint(),baslikFont: UIFont.boldSystemFont(ofSize: 15))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        let lblPhoto = UILabel(text: "Yeni Gönderi", font: .boldSystemFont(ofSize: 14), textColor: .black, textAlignment: .center)

        golgeEkle(opacity: 0.15, yaricap: 10, offset: .init(width: 0, height: 10), renk: .init(white: 0, alpha: 0.2))
  
        
        addSubview(btnBack)
        btnBack.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: nil, paddingTop: 2, paddingBottom: 0, paddingLeft: 10, paddingRight: 0, width: 0, height: 0)
        addSubview(lblPhoto)
        lblPhoto.anchor(top: topAnchor, bottom: bottomAnchor, leading: btnBack.trailingAnchor, trailing: lblPhoto.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        addSubview(btnShare)
        btnShare.anchor(top: topAnchor, bottom: bottomAnchor, leading: lblPhoto.trailingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: -5, width: 0, height: 0)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
