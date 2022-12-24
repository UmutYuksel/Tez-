//
//  FotografPaylasController.swift
//  deneme
//
//  Created by Umut Yüksel on 26.10.2022.
//

import UIKit
import JGProgressHUD
import Firebase
import FirebaseStorage

class FotografPaylasController : UIViewController {
    var secilenFotograf : UIImage? {
        didSet {
            self.imgPaylasim.image = secilenFotograf
        }
    }
    let txtMesaj : UITextView = {
        let txt = UITextView()
        txt.font = UIFont.systemFont(ofSize: 15)
        return txt
    }()
    let imgPaylasim : UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgbDonustur(red: 240, green: 240, blue: 240)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Paylaş", style: .plain, target: self, action: #selector(btnPaylasPressed))
        fotografMesajAlanlariniOlustur()
    }
    
    fileprivate func fotografMesajAlanlariniOlustur() {
        
        let paylasimView = UIView()
        paylasimView.backgroundColor = .white
        
        view.addSubview(paylasimView)
        paylasimView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 120)
        
        view.addSubview(imgPaylasim)
        imgPaylasim.anchor(top: paylasimView.topAnchor, bottom: paylasimView.bottomAnchor, leading: paylasimView.leadingAnchor, trailing: nil, paddingTop: 8, paddingBottom: -8, paddingLeft: 8, paddingRight: 0, width: 85, height: 0)
        view.addSubview(txtMesaj)
        
        txtMesaj.anchor(top: paylasimView.topAnchor, bottom: paylasimView.bottomAnchor, leading: imgPaylasim.trailingAnchor, trailing: paylasimView.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 5, paddingRight: 0, width: 0, height: 0)
    }
    
    @objc fileprivate func btnPaylasPressed() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Paylaşım Yükleniyor"
        hud.show(in: self.view)
        
        let fotografAdi = UUID().uuidString
        guard let paylasimFotograf = secilenFotograf else { return }
        let fotografData = paylasimFotograf.jpegData(compressionQuality: 0.8) ?? Data()
        
        let ref = Storage.storage().reference(withPath: "/Paylasimlar/\(fotografAdi)")
        
        ref.putData(fotografData,metadata:nil) { (_ , hata) in
            if let hata = hata {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Fotoğraf Kaydedilemedi",hata)
                hud.textLabel.text = "Fotoğraf Yüklenirken Hata Oldu"
                hud.dismiss(afterDelay: 2)
                return
            }
            print("Paylaşılan Fotoğraf Başarı İle Upload Edildi")
            ref.downloadURL { (url,hata) in
                hud.textLabel.text = "Fotoğraf Yüklendi"
                hud.dismiss(afterDelay: 2)
                if let hata = hata {
                    print("Fotoğrafın URL Adresi Alınamadı",hata)
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                }
                print("Upload Edilen Fotoğrafın URL Adresi : \(url?.absoluteString)")
                if let url = url {
                    self.paylasimKaydetFS(goruntuURL: url.absoluteString)
                }
            }
        }
        
    }
    static let guncelleNotification = Notification.Name("PaylasimlariGuncelle")
  
    fileprivate func paylasimKaydetFS(goruntuURL : String) {
        let db = Firestore.firestore()
        guard let paylasimFotograf = secilenFotograf else { return }
        guard let mesaj = txtMesaj.text,
              mesaj.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 else { return }
        
        
        guard let gecerliKullaniciID = Auth.auth().currentUser?.uid else { return }
        let eklenecekVeri = ["KullaniciID" : gecerliKullaniciID,
                             "PaylasimGoruntuURL": goruntuURL,
                             "Mesaj" : mesaj,
                             "GoruntuGenislik" : paylasimFotograf.size.width,
                             "GoruntuYukseklik" : paylasimFotograf.size.height,
                             "PaylasimTarihi" : Timestamp(date: Date())] as [String : Any]
        var ref : DocumentReference? = nil
        ref = Firestore.firestore().collection("Paylasimlar").document(gecerliKullaniciID).collection("Fotograf_Paylasimlari").addDocument(data: eklenecekVeri, completion: { (hata) in
            if let hata = hata {
                print("Paylaşım Kaydedilirken Hata Meydana Geldi",hata)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                return
            }
            print("Paylaşım Başarı İle Kaydedildi Ve Paylaşım Döküman ID'si :",ref?.documentID)
            self.dismiss(animated: true,completion: nil)
            
            
            NotificationCenter.default.post(name: FotografPaylasController.guncelleNotification, object: nil)
        })
        let paylasimSayisi = db.collection("Kullanicilar").document(gecerliKullaniciID)
        paylasimSayisi.updateData([
            "PaylasimSayisi" : FieldValue.increment(Int64(1))
        ])
    }
}
