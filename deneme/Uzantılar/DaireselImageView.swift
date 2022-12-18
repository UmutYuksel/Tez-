//
//  DaireselImageView.swift
//  tez
//
//  Created by Umut Yüksel on 17.12.2022.
//

import UIKit

open class DaireselImageView : UIImageView {
    
    public init(genislik : CGFloat, image: UIImage? = nil) {
        super.init(image: image)
        contentMode = .scaleToFill
        
        if genislik != 0 {
            widthAnchor.constraint(equalToConstant: genislik).isActive = true
        }
        heightAnchor.constraint(equalToConstant: genislik).isActive = true
        clipsToBounds = true
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
