//
//  KullanıcıProfilHeader.swift
//  deneme
//
//  Created by Umut Yüksel on 17.10.2022.
//

import Foundation
import UIKit
import Firebase
import SDWebImage
import FirebaseFirestore

class KullanıcıProfilHeader : UICollectionViewCell {
    var gecerliKullanici : Kullanici? {
        didSet{
            guard let url = URL(string: gecerliKullanici?.profilGoruntuURL ?? "") else { return }
            imgProfilGoruntu.sd_setImage(with: url, completed: nil)
            lbnKullaniciAdi.text = gecerliKullanici?.kullaniciAdi
        }
    }
        let btnProfilDuzenle : UIButton = {
            let btn = UIButton(type: .system)
            btn.setTitle("Profil Düzenle", for: .normal)
            btn.setTitleColor(.black, for: .normal)
            btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            btn.layer.borderColor = UIColor.lightGray.cgColor
            btn.layer.borderWidth = 1
            btn.layer.cornerRadius = 5
            return btn
        }()
        let lblPaylasim : UILabel = {
            let lbl = UILabel()
            let attrText = NSMutableAttributedString(string: "10\n",attributes: [.font : UIFont.boldSystemFont(ofSize: 16)])
            attrText.append(NSAttributedString(string: "Paylaşım",attributes: [.foregroundColor : UIColor.darkGray, .font : UIFont.systemFont(ofSize: 14)]))
            lbl.attributedText = attrText
            lbl.textAlignment = .center
            lbl.numberOfLines = 0
        return lbl
        }()
        let lblTakipci : UILabel = {
            let lbl = UILabel()
                let attrText = NSMutableAttributedString(string: "2.5M\n",attributes: [.font : UIFont.boldSystemFont(ofSize: 16)])
            attrText.append(NSAttributedString(string: "Takipçi",attributes: [.foregroundColor : UIColor.darkGray, .font : UIFont.systemFont(ofSize: 14)]))
            lbl.attributedText = attrText
            lbl.textAlignment = .center
            lbl.numberOfLines = 0
            return lbl
        }()
        let lblTakipEdiyor : UILabel = {
            let lbl = UILabel()
            let attrText = NSMutableAttributedString(string: "10\n",attributes: [.font : UIFont.boldSystemFont(ofSize: 16)])
            attrText.append(NSAttributedString(string: "Takip Ediyor",attributes: [.foregroundColor :   UIColor.darkGray, .font : UIFont.systemFont(ofSize: 14)]))
            lbl.attributedText = attrText
            lbl.textAlignment = .center
            lbl.numberOfLines = 0
            return lbl
        }()
    
        let lbnKullaniciAdi : UILabel = {
            let lbn = UILabel()
            lbn.font = UIFont.boldSystemFont(ofSize: 15)
            return lbn
        }()
    
        let btnGrid : UIButton = {
            let btn = UIButton(type: .system)
            btn.setImage(UIImage(named: "mesh.png"), for: .normal)
            return btn
        }()
        
        let btnListe : UIButton = {
            let btn = UIButton(type: .system)
            btn.setImage(UIImage(named: "list.png"), for: .normal)
            btn.tintColor = UIColor(white: 0, alpha: 0.2)
            return btn
        }()
        
        let btnYerIsareti : UIButton = {
            let btn = UIButton(type: .system)
            btn.setImage(UIImage(named: "save.png"), for: .normal)
            btn.tintColor = UIColor(white: 0 , alpha: 0.2)
            return btn
        }()
        let imgProfilGoruntu : UIImageView = {
            let img = UIImageView()
            return img
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imgProfilGoruntu)
        let goruntuBoyut : CGFloat = 90
        imgProfilGoruntu.anchor(top: topAnchor, bottom: nil, leading: self.leadingAnchor, trailing: nil, paddingTop: 15, paddingBottom: 0, paddingLeft: 15, paddingRight: 0, width: goruntuBoyut, height: goruntuBoyut)
        imgProfilGoruntu.layer.cornerRadius = goruntuBoyut / 2
        imgProfilGoruntu.clipsToBounds = true
        toolbarOlustur()
        
        addSubview(lbnKullaniciAdi)
        lbnKullaniciAdi.anchor(top: imgProfilGoruntu.bottomAnchor, bottom: btnGrid.topAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 5, paddingBottom: 0, paddingLeft: 15, paddingRight: 15, width: 0, height: 0)
        
        kullaniciDurumBilgisiGoster()
        addSubview(btnProfilDuzenle)
        btnProfilDuzenle.anchor(top: lblPaylasim.bottomAnchor, bottom: nil, leading: lblPaylasim.leadingAnchor, trailing: lblTakipEdiyor.trailingAnchor, paddingTop: 10, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 35)
    }
    
    fileprivate func kullaniciDurumBilgisiGoster() {
        let stackView = UIStackView(arrangedSubviews: [lblPaylasim,lblTakipci,lblTakipEdiyor])
        addSubview(stackView)
        stackView.distribution = .fillEqually
        stackView.anchor(top: topAnchor, bottom: nil, leading: imgProfilGoruntu.trailingAnchor, trailing: trailingAnchor, paddingTop: 15, paddingBottom: 0, paddingLeft: 15, paddingRight: -15, width: 0, height: 50)
    }
    
    fileprivate func toolbarOlustur() {
        
        let ustAyracView = UIView()
        ustAyracView.backgroundColor = UIColor.lightGray
        
        let altAyracView = UIView()
        altAyracView.backgroundColor = UIColor.lightGray
        
        let stackView = UIStackView(arrangedSubviews: [btnGrid,btnListe,btnYerIsareti])
        
        addSubview(stackView)
        addSubview(ustAyracView)
        addSubview(altAyracView)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.anchor(top: nil, bottom: self.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 50)
        ustAyracView.anchor(top: stackView.topAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
        altAyracView.anchor(top: stackView.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
