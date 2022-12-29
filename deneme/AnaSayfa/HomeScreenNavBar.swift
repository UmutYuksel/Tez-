//
//  HomeScreenNavBar.swift
//  tez
//
//  Created by Umut Yüksel on 26.12.2022.
//

import Foundation
import UIKit

class HomeScreenNavBar : UIView {
    
    let btnMessages = UIButton(image: UIImage(named: "message-i.png")!.withRenderingMode(.alwaysOriginal))
    let btnSharePhoto = UIButton(image: UIImage(named: "new-message32c.png")!.withRenderingMode(.alwaysOriginal))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        let imgAppIcon = UIImageView(image: UIImage(named: "food-c.png"))

        golgeEkle(opacity: 0.15, yaricap: 10, offset: .init(width: 0, height: 10), renk: .init(white: 0, alpha: 0.2))
        
        addSubview(imgAppIcon)
        imgAppIcon.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: nil, paddingTop: 2, paddingBottom: 0, paddingLeft: 6.5, paddingRight: 0, width: 0, height: 0)
        addSubview(btnSharePhoto)
        btnSharePhoto.anchor(top: topAnchor, bottom: bottomAnchor, leading: nil, trailing: btnSharePhoto.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 35, width: 0, height: 0)
        addSubview(btnMessages)
        btnMessages.anchor(top: topAnchor, bottom: bottomAnchor, leading: btnSharePhoto.trailingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 35, paddingRight: -20, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


