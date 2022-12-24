//
//  LastMessageNavBar.swift
//  tez
//
//  Created by Umut Yüksel on 20.12.2022.
//

import Foundation
import UIKit

class LastMessageNavBar : UIView {
    
    let btnBack = UIButton(image: UIImage(named: "back-arrow-c.png")!.withRenderingMode(.alwaysOriginal))
    let btnNewMessage = UIButton(image: (UIImage(named: "new-message32c.png")!.withRenderingMode(.alwaysOriginal)))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        let imgMessage = UIImageView(image: UIImage(named: "message-not.png")!.withRenderingMode(.alwaysOriginal), contentMode: .scaleAspectFit)
        
        let lblMessages = UILabel(text: "Mesajlar", font: .boldSystemFont(ofSize: 16), textColor: UIColor.orangeTint(), textAlignment: .center)
        
        golgeEkle(opacity: 0.15, yaricap: 10, offset: .init(width: 0, height: 10), renk: .init(white: 0, alpha: 0.2))
        
        let middleSV =
        yatayStackViewOlustur(stackViewOlustur(imgMessage,lblMessages,alignment: .center),alignment: .center)
        
        yatayStackViewOlustur(btnBack,middleSV,btnNewMessage,distribution: .fillEqually)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
