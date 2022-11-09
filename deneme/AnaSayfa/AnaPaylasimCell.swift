//
//  AnaPaylasimCell.swift
//  deneme
//
//  Created by Umut Yüksel on 28.10.2022.
//

import UIKit

class AnaPaylasimCell : UICollectionViewCell {
    
    var paylasim : Paylasim? {
        didSet {
            guard let url = paylasim?.paylasimGoruntuURL
                    , let goruntuURL = URL(string: url) else { return }
            imgPaylasimFoto.sd_setImage(with: goruntuURL,completed: nil)
            
        }
    }
    let btnLike : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "heart.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    
    let BtnSentMessage :  UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "sent.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    let BtnComment : UIButton =  {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "comment.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    let btnSecenekler : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("•••", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()
    let lblKullaniciAdi : UILabel = {
        let lbl = UILabel()
        lbl.text = "Kullanıcı Adı"
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        return lbl
    }()
    
    let imgKullaniciProfilFoto : UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.backgroundColor = .blue
        return img
    }()
    
    let imgPaylasimFoto : UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray
        addSubview(imgKullaniciProfilFoto)
        addSubview(lblKullaniciAdi)
        addSubview(btnSecenekler)
        addSubview(imgPaylasimFoto)
        
        imgKullaniciProfilFoto.anchor(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, paddingTop: 8, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 40, height: 40)
        imgKullaniciProfilFoto.layer.cornerRadius = 40/2
        
        lblKullaniciAdi.anchor(top: topAnchor, bottom: imgPaylasimFoto.topAnchor, leading: imgKullaniciProfilFoto.trailingAnchor, trailing: btnSecenekler.leadingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 0, height: 0)
        
        btnSecenekler.anchor(top: topAnchor, bottom: imgPaylasimFoto.topAnchor, leading: nil, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 45, height: 0)
        
        imgPaylasimFoto.anchor(top: imgKullaniciProfilFoto.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 8, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        _ = imgPaylasimFoto.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        
    }
    fileprivate func etkilesimButonlarıOlustur() {
        let stackView = UIStackView(arrangedSubviews: [btnLike,BtnComment,BtnSentMessage])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: imgPaylasimFoto.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 120, height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
