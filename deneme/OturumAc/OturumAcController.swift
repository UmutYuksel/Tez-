//
//  OturumAcController.swift
//  deneme
//
//  Created by Umut Yüksel on 21.10.2022.
//

import Foundation
import UIKit
import Firebase
import JGProgressHUD

class OturumAcController : UIViewController {
    
    let txtEmail : UITextField = {
        let txt = UITextField()
        txt.placeholder = "Email adresinizi giriniz"
        txt.backgroundColor = UIColor(white: 0, alpha: 0.05)
        txt.borderStyle = .roundedRect
        txt.font = UIFont.systemFont(ofSize: 16)
        txt.addTarget(self, action: #selector(veriDegisimi), for: .editingChanged)
        return txt
    }()
    
    let txtParola : UITextField = {
        let txt = UITextField()
        txt.placeholder = "Parolanız"
        txt.isSecureTextEntry = true
        txt.backgroundColor = UIColor(white: 0, alpha: 0.05)
        txt.borderStyle = .roundedRect
        txt.font = UIFont.systemFont(ofSize: 16)
        txt.addTarget(self, action: #selector(veriDegisimi), for: .editingChanged)
        return txt
    }()
    
    let btnGirisYap : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Giriş Yap", for: .normal)
        btn.backgroundColor = UIColor.rgbDonustur(red: 150, green: 205, blue: 245)
        btn.layer.cornerRadius = 6
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.setTitleColor(.white, for: .normal)
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(btnGirisYapPressed), for: .touchUpInside)
        return btn
    }()
    
    @objc fileprivate func btnGirisYapPressed() {
        
        guard let emailAdresi = txtEmail.text , let parola = txtParola.text else { return }
        
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Oturum Açılıyor."
        hud.show(in: self.view)
        
        Auth.auth().signIn(withEmail: emailAdresi, password: parola) { (sonuc, hata) in
            
            if let hata = hata {
                print("Oturum Açılırken Hata Meydana Geldi",hata)
                hud.dismiss(animated: true)
                let basarisizHud = JGProgressHUD(style: .light)
                basarisizHud.textLabel.text = "Oturum Açılırken Hata Meydana Geldi \(hata.localizedDescription)"
                basarisizHud.show(in: self.view)
                basarisizHud.dismiss(afterDelay: 2)
                return
            }
            print("Kullanıcı Oturumu Açıldı",sonuc?.user.uid)
            
            let keyWindow = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            guard let anaTabBarController = keyWindow?.rootViewController as? AnaTabBarController else { return }
            anaTabBarController.gorunumuOlustur() // KullanıcıProfilContollera Gidilir
            self.dismiss(animated: true, completion: nil) // Oturum Açma Ekranını Kapatmak İçin
            
            
            hud.dismiss(animated: true)
            let basariliHud = JGProgressHUD(style: .light)
            basariliHud.textLabel.text = "Oturum Açma Başarılı"
            basariliHud.show(in: self.view)
            basariliHud.dismiss(afterDelay: 1)
            
        }
    }
    
    let logoView : UIView = {
        let view = UIView()
        let imgLogo = UIImageView()
        imgLogo.image = UIImage(named: "food-c.png")
        view.addSubview(imgLogo)
        imgLogo.contentMode = .scaleAspectFill
        imgLogo.anchor(top: nil, bottom: nil, leading: nil, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 200, height: 50)
        imgLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imgLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.backgroundColor = UIColor.rgbDonustur(red: 0, green: 120, blue: 175)
        return view
    }()
    
    let btnKayitOl : UIButton = {
        let btn = UIButton(type: .system)
        
        let attrBaslik = NSMutableAttributedString(string: "Henüz bir hesabınız yok mu?",attributes: [.font : UIFont.systemFont(ofSize: 16),.foregroundColor : UIColor.lightGray])
        attrBaslik.append(NSMutableAttributedString(string: " Kayıt Ol.",attributes: [.font : UIFont.boldSystemFont(ofSize: 16), .foregroundColor : UIColor.rgbDonustur(red: 20, green: 155, blue: 235)]))
        btn.setAttributedTitle(attrBaslik, for: .normal)
            
        
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(btnKayitOlPressed), for: .touchUpInside)
        return btn
    }()
    
    @objc fileprivate func veriDegisimi() {
        let formGecerliMi = (txtEmail.text?.count ?? 0) > 0 &&
        (txtParola.text?.count ?? 0) > 0
        if formGecerliMi {
            btnGirisYap.isEnabled = true
            btnGirisYap.backgroundColor = UIColor.rgbDonustur(red: 20, green: 155, blue: 235)
        } else {
            btnGirisYap.isEnabled = false
            btnGirisYap.backgroundColor = UIColor.rgbDonustur(red: 150, green: 205, blue: 245)
        }
    }
    
    @objc fileprivate func btnKayitOlPressed() {
        let kayitOlController = KayitOlController()
        
        navigationController?.pushViewController(kayitOlController, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(logoView)
        logoView.anchor(top: view.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 150)
        
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(btnKayitOl)
        btnKayitOl.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 50)
        girisGorunumOlustur()
    }
    
    fileprivate func girisGorunumOlustur() {
        let stackView = UIStackView(arrangedSubviews: [txtEmail,txtParola,btnGirisYap])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.anchor(top: logoView.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 40, paddingBottom: 0, paddingLeft: 40, paddingRight: -40, width: 0, height: 185)
    }
}
