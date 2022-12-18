//
//  UiTextView.swift
//  tez
//
//  Created by Umut Yüksel on 17.12.2022.
//

import UIKit

extension UITextView {
    
    convenience init(text : String?, font : UIFont? = UIFont.systemFont(ofSize: 15), textColor : UIColor = .black, textAlignment : NSTextAlignment = .left) {
        
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
    }
}
