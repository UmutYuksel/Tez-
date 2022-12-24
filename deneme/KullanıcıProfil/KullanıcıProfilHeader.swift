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

protocol KullanıcıProfilHeaderDelegate {
    func gridGorunumuneGec()
    func listeGorunumuneGec()
    func getUserProfileData()

}

class KullanıcıProfilHeader : UICollectionViewCell {
    
    var delegate : KullanıcıProfilHeaderDelegate?
    
    var gecerliKullanici : Kullanici? {
        didSet{
            
            takipButonuAyarla()
            guard let url = URL(string: gecerliKullanici?.profilGoruntuURL ?? "") else { return }
            imgProfilGoruntu.sd_setImage(with: url, completed: nil)
            lblKullaniciAdi.text = gecerliKullanici?.kullaniciAdi
            attrTakipEdiyorOlustur()
            attrTakipciOlustur()
            attrPaylasimOlustur()

        }
    }
    
    fileprivate func takipButonuAyarla() {
        
        guard let oturumKID = Auth.auth().currentUser?.uid else { return }
        guard let gecerliKID = gecerliKullanici?.kullaniciID else { return }
        
        
        Firestore.firestore().collection("Kullanicilar").document(oturumKID).collection("TakipEdiyor").document(oturumKID).getDocument { (snapshot, hata) in
            
        }
        
        
        
        if oturumKID != gecerliKID {
            
            Firestore.firestore().collection("Kullanicilar").document(oturumKID).collection("TakipEdiyor").document(oturumKID).getDocument { (snapshot,hata)  in
                if let hata = hata {
                    print("Takip Verisi Alınamadı : \(hata.localizedDescription)")
                    return
                }
                guard let takipVerileri = snapshot?.data() else { return }
                
                if let veri = takipVerileri[gecerliKID] {
                    let takip = veri as! Int
                    print(takip)
                    if takip == 1 {
                        self.btnProfilDuzenle.setTitle("Takipten Çık", for: .normal)
                    }
                } else {
                    self.btnProfilDuzenle.setTitle("Takip Et", for: .normal)
                    self.btnProfilDuzenle.backgroundColor = UIColor.rgbDonustur(red: 20, green: 155, blue: 240)
                    self.btnProfilDuzenle.setTitleColor(.white, for: .normal)
                    self.btnProfilDuzenle.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
                    self.btnProfilDuzenle.layer.borderWidth = 1
                }
            }
        } else {
            self.btnProfilDuzenle.setTitle("Profili Düzenle", for: .normal)
            btnProfilDuzenle.isEnabled = false
        }
    }
        lazy var btnProfilDuzenle : UIButton = {
            let btn = UIButton(type: .system)
            btn.setTitleColor(.black, for: .normal)
            btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            btn.layer.borderColor = UIColor.lightGray.cgColor
            btn.layer.borderWidth = 1
            btn.layer.cornerRadius = 5
            btn.addTarget(self, action: #selector(btnProfil_Takip_Duzenle), for: .touchUpInside)
            return btn
        }()

 
    @objc fileprivate func btnProfil_Takip_Duzenle() {
        
        guard let oturumuAcanKID = Auth.auth().currentUser?.uid else { return }
        guard let gecerliKID = gecerliKullanici?.kullaniciID else { return }
        let db = Firestore.firestore()
        
        // Takip Ediyor İse Takipten Çıkartır
        if btnProfilDuzenle.titleLabel?.text == "Takipten Çık" {
            Firestore.firestore().collection("Kullanicilar").document(oturumuAcanKID).collection("TakipEdiyor").document(oturumuAcanKID).updateData([gecerliKID : FieldValue.delete()]) { (hata) in
                if let hata = hata {
                    print("Takipten Çıkartırken Hata Meydana Geldi : \(hata.localizedDescription)")
                }
                self.btnProfilDuzenle.backgroundColor = UIColor.rgbDonustur(red: 20, green: 155, blue: 240)
                self.btnProfilDuzenle.setTitleColor(.white, for: .normal)
                self.btnProfilDuzenle.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
                self.btnProfilDuzenle.layer.borderWidth = 1
                self.btnProfilDuzenle.setTitle("Takip Et", for: .normal)
            }
            let takipEdiyorSayisi = db.collection("Kullanicilar").document(oturumuAcanKID)
            takipEdiyorSayisi.updateData([
                "TakipEdiyorSayisi" : FieldValue.increment(Int64(-1))
            ])
            let takipciSayisi = db.collection("Kullanicilar").document(gecerliKID)
            takipciSayisi.updateData([
                "TakipciSayisi" : FieldValue.increment(Int64(-1))
            ])
            
            return
            
        }
        
        let eklenecekDeger = [gecerliKID : 1]
        
        Firestore.firestore().collection("Kullanicilar").document(oturumuAcanKID).collection("TakipEdiyor").document(oturumuAcanKID).getDocument { (snapshot, hata) in
            if let hata = hata {
                print("Takip Verisi Alınamadı : \(hata.localizedDescription)")
                return
            }
            // Takip Verisini Güncellemek İçin
            if snapshot?.exists == true {
                Firestore.firestore().collection("Kullanicilar").document(oturumuAcanKID).collection("TakipEdiyor").document(oturumuAcanKID).updateData(eklenecekDeger) {
                    (hata) in
                    if let hata = hata {
                        print("Takip Verisi Güncellemesi Başarısız : \(hata.localizedDescription)")
                        return
                    }
                    self.btnProfilDuzenle.setTitle("Takipten Çık", for: .normal)
                    self.btnProfilDuzenle.setTitleColor(.black, for: .normal)
                    self.btnProfilDuzenle.backgroundColor = .white
                    self.btnProfilDuzenle.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
                    self.btnProfilDuzenle.layer.borderColor = UIColor.lightGray.cgColor
                    self.btnProfilDuzenle.layer.borderWidth = 1
                    self.btnProfilDuzenle.layer.cornerRadius = 5
                }
                let takipEdiyorSayisi = db.collection("Kullanicilar").document(oturumuAcanKID)
                takipEdiyorSayisi.updateData([
                    "TakipEdiyorSayisi" : FieldValue.increment(Int64(1))
                ])
                let takipciSayisi = db.collection("Kullanicilar").document(gecerliKID)
                takipciSayisi.updateData([
                    "TakipciSayisi" : FieldValue.increment(Int64(1))
                ])
                self.delegate?.getUserProfileData()
            }
            // Takip Etmeye Yeni Başladı İse
            else {
                Firestore.firestore().collection("Kullanicilar").document(oturumuAcanKID).collection("TakipEdiyor").document(oturumuAcanKID).setData(eklenecekDeger) { (hata) in
                    if let hata = hata  {
                        print("Takip Verisi Kaydı Başarısız : \(hata.localizedDescription)")
                        return
                    }
                }
                let takipEdiyorSayisi = db.collection("Kullanicilar").document(oturumuAcanKID)
                takipEdiyorSayisi.updateData([
                    "TakipEdiyorSayisi" : FieldValue.increment(Int64(1))
                ])
                let takipciSayisi = db.collection("Kullanicilar").document(gecerliKID)
                takipciSayisi.updateData([
                    "TakipciSayisi" : FieldValue.increment(Int64(1))
                ])
                self.delegate?.getUserProfileData()
            }
        }
        
    }
    
        fileprivate func attrPaylasimOlustur() {
            let attrText = NSMutableAttributedString(string: "\(gecerliKullanici?.paylasimCount ?? 0)\n",attributes: [.font : UIFont.boldSystemFont(ofSize: 16)])
            attrText.append(NSAttributedString(string: "Paylaşım",attributes: [.foregroundColor : UIColor.darkGray, .font : UIFont.systemFont(ofSize: 14)]))
            lblPaylasim.attributedText = attrText
        }
    
        let lblPaylasim : UILabel = {
            let lbl = UILabel()
            lbl.textAlignment = .center
            lbl.numberOfLines = 0
        return lbl
        }()
    
        fileprivate func attrTakipciOlustur() {
            let attrText = NSMutableAttributedString(string: "\(gecerliKullanici?.takipciCount ?? 0)\n",attributes: [.font : UIFont.boldSystemFont(ofSize: 16)])
            attrText.append(NSAttributedString(string: "Takipçi",attributes: [.foregroundColor : UIColor.darkGray, .font : UIFont.systemFont(ofSize: 14)]))
            lblTakipci.attributedText = attrText
        }
    
        let lblTakipci : UILabel = {
            let lbl = UILabel()
            lbl.textAlignment = .center
            lbl.numberOfLines = 0
            return lbl
        }()
        
        fileprivate func attrTakipEdiyorOlustur() {
            let attrText = NSMutableAttributedString(string: "\(gecerliKullanici?.takipEdiyorCount ?? 0)\n",attributes: [.font : UIFont.boldSystemFont(ofSize: 16)])
            attrText.append(NSAttributedString(string: "Takip Ediyor",attributes: [.foregroundColor : UIColor.darkGray, .font : UIFont.systemFont(ofSize: 14)]))
            lblTakipEdiyor.attributedText = attrText
        }
        
        let lblTakipEdiyor : UILabel = {
            let lbl = UILabel()
            lbl.textAlignment = .center
            lbl.numberOfLines = 0
            return lbl
        }()
    
        let lblKullaniciAdi : UILabel = {
            let lbl = UILabel()
            lbl.text = "Kullanıcı Adı"
            lbl.font = UIFont.boldSystemFont(ofSize: 15)
            return lbl
        }()
    
        lazy var btnGrid : UIButton = {
            let btn = UIButton(type: .system)
            btn.setImage(UIImage(named: "mesh.png"), for: .normal)
            btn.addTarget(self, action: #selector(btnGridPressed), for: .touchUpInside)
            return btn
        }()
    
    @objc fileprivate func btnGridPressed() {
        btnGrid.tintColor = .anaMavi()
        btnListe.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.gridGorunumuneGec()
    }
        
        lazy var btnListe : UIButton = {
            let btn = UIButton(type: .system)
            btn.setImage(UIImage(named: "list.png"), for: .normal)
            btn.tintColor = UIColor(white: 0, alpha: 0.2)
            btn.addTarget(self, action: #selector(btnListePressed), for: .touchUpInside)
            return btn
        }()
    
    @objc fileprivate func btnListePressed() {
        btnListe.tintColor = .anaMavi()
        btnGrid.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.listeGorunumuneGec()
    }
        
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
        
        addSubview(lblKullaniciAdi)
        lblKullaniciAdi.anchor(top: imgProfilGoruntu.bottomAnchor, bottom: btnGrid.topAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 5, paddingBottom: 0, paddingLeft: 15, paddingRight: 15, width: 0, height: 0)
        
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
        
        let stackView = UIStackView(arrangedSubviews: [btnGrid,btnListe])
        
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
