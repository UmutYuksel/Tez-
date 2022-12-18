//
//  AnaPaylasimCell.swift
//  deneme
//
//  Created by Umut Yüksel on 28.10.2022.
//

import UIKit
import Firebase

protocol AnaPaylasimCellDelegate {
    
    func CommentPressed(paylasim : Paylasim)
    func LikePressed(cell : AnaPaylasimCell)
    
}

class AnaPaylasimCell : UICollectionViewCell {
    
    var delegate : AnaPaylasimCellDelegate?
    var paylasim : Paylasim? {
        didSet {
            guard let url = paylasim?.paylasimGoruntuURL
                    , let goruntuURL = URL(string: url) else { return }
            imgPaylasimFoto.sd_setImage(with: goruntuURL,completed: nil)
            lblKullaniciAdi.text = paylasim?.kullanici.kullaniciAdi
            
            guard let pUrl = paylasim?.kullanici.profilGoruntuURL,
                  let profilGoruntuURL = URL(string: pUrl) else {return}
            imgKullaniciProfilFoto.sd_setImage(with: profilGoruntuURL, completed: nil)
            
            attrPaylasimMesajıOlustur()
            
            if paylasim?.begenildi == true {
                btnLike.setImage(UIImage(named: "heart-selected24.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
            } else {
                btnLike.setImage(UIImage(named: "heart24.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
            
        }
    }
    fileprivate func attrPaylasimMesajıOlustur() {
        guard let paylasim = self.paylasim else { return }
        let attrText = NSMutableAttributedString(string: paylasim.kullanici.kullaniciAdi ,attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        attrText.append(NSAttributedString(string: " \(paylasim.mesaj ?? "Veri Yok")",attributes: [.font : UIFont.systemFont(ofSize: 14)]))
        attrText.append(NSAttributedString(string: "\n\n",attributes: [.font : UIFont.systemFont(ofSize: 4)]))
        
        let paylasimZaman = paylasim.paylasimTarihi.dateValue()
        attrText.append(NSAttributedString(string: paylasimZaman.zamanHesapla(),attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor : UIColor.gray]))
        
        lblDescription.attributedText = attrText
    }
    let lblDescription : UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        return lbl
    }()
    let btnBookmark : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "bookmark.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    lazy var btnLike : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "heart24.png")?.withRenderingMode(.alwaysOriginal),for: .normal)
        btn.addTarget(self, action: #selector(btnLikePressed), for: .touchUpInside)
        return btn
    }()
    
    @objc fileprivate func btnLikePressed() {
        print("Paylaşım beğendi")
        delegate?.LikePressed(cell: self)
    }
    
    let BtnSentMessage :  UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "sent 1.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    lazy var BtnComment : UIButton =  {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "comment 1.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(btnCommentPressed), for:.touchUpInside)
        return btn
    }()
    
    @objc fileprivate func btnCommentPressed() {
        guard let paylasim = self.paylasim else { return }
        delegate?.CommentPressed(paylasim: paylasim)
    }
    
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
        backgroundColor = .white
        addSubview(imgKullaniciProfilFoto)
        addSubview(lblKullaniciAdi)
        addSubview(btnSecenekler)
        addSubview(imgPaylasimFoto)
        
        imgKullaniciProfilFoto.anchor(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, paddingTop: 8, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 40, height: 40)
        imgKullaniciProfilFoto.layer.cornerRadius = 40/2
        
        lblKullaniciAdi.anchor(top: topAnchor, bottom: imgPaylasimFoto.topAnchor, leading: imgKullaniciProfilFoto.trailingAnchor, trailing: btnSecenekler.leadingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 0, height: 0)
        
        btnSecenekler.anchor(top: topAnchor, bottom: imgPaylasimFoto.topAnchor, leading: nil, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 45, height: 0)
        
        imgPaylasimFoto.anchor(top: imgKullaniciProfilFoto.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 5, paddingBottom: 8, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        _ = imgPaylasimFoto.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        etkilesimButonlarıOlustur()
        
        
    }
   
    fileprivate func etkilesimButonlarıOlustur() {
        let stackView = UIStackView(arrangedSubviews: [btnLike,BtnComment,BtnSentMessage])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: imgPaylasimFoto.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 120, height: 50)
        
        addSubview(btnBookmark)
        btnBookmark.anchor(top: imgPaylasimFoto.bottomAnchor, bottom: nil, leading: nil, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 40, height: 50)
        
        addSubview(lblDescription)
        lblDescription.anchor(top: btnLike.bottomAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: -8, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
