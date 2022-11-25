//
//  CommentsCell.swift
//  tez
//
//  Created by Umut Yüksel on 25.11.2022.
//

import UIKit

class YorumCell : UICollectionViewCell {
    
    var yorum : Yorum? {
        didSet{
            lblComment.text = yorum?.yorumMesaji ?? "Veri Yok"
        }
    }
    
    let lblComment : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.numberOfLines = 0
        lbl.backgroundColor = .lightGray
        return lbl
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(lblComment)
        
        lblComment.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 5, paddingBottom: -5, paddingLeft: 5, paddingRight: -5, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
