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
            guard let yorum = yorum else { return }
            imgKullaniciProfil.sd_setImage(with: URL(string: yorum.kullanici.profilGoruntuURL), completed: nil)
            
            let attrText = NSMutableAttributedString(string: yorum.kullanici.kullaniciAdi, attributes: [.font : UIFont.boldSystemFont(ofSize: 15)])
            
            attrText.append(NSAttributedString(string: " " + (yorum.yorumMesaji), attributes: [.font : UIFont.systemFont(ofSize: 15)]))
            
            lblComment.attributedText = attrText
        }
    }
    
    let lblComment : UITextView = {
        let lbl = UITextView()
        lbl.isEditable = false
        lbl.isScrollEnabled = false
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        return lbl
    }()
    
    let imgKullaniciProfil : UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 50 / 2
        return img
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imgKullaniciProfil)
        imgKullaniciProfil.anchor(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, paddingTop: 5, paddingBottom: 0, paddingLeft: 10, paddingRight: 5, width: 50, height: 50)
        
        addSubview(lblComment)
        
        lblComment.anchor(top: topAnchor, bottom: bottomAnchor, leading: imgKullaniciProfil.trailingAnchor, trailing: trailingAnchor, paddingTop: 5, paddingBottom: -5, paddingLeft: 10, paddingRight: -5, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
