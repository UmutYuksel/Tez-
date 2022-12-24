//
//  CameControllerNavBar.swift
//  tez
//
//  Created by Umut Yüksel on 23.12.2022.
//

import UIKit

class CameControllerNavBar : UIView {
    
    let btnShare = UIButton(image: UIImage(named: "right-arrowc.png")!.withRenderingMode(.alwaysOriginal))
    let btnBack = UIButton(image: UIImage(named: "left-edge.png")!.withRenderingMode(.alwaysOriginal))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        let lblMessages = UILabel(text: "Paylaşılacak Fotoğraf", font: .systemFont(ofSize: 16), textColor: UIColor.orangeTint(), textAlignment: .center)
        
        golgeEkle(opacity: 0.15, yaricap: 10, offset: .init(width: 0, height: 10), renk: .init(white: 0, alpha: 0.2))
        
        yatayStackViewOlustur(btnBack,lblMessages,btnShare,distribution: .fillEqually)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
