//
//  UiLabel.swift
//  tez
//
//  Created by Umut Yüksel on 17.12.2022.
//

import UIKit

extension UILabel {
    
    convenience init(text : String? = nil, font : UIFont? = UIFont.systemFont(ofSize: 15), textColor : UIColor = .black, textAlignment : NSTextAlignment = .left, numberofLines : Int = 1) {
        
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberofLines
    }
}
