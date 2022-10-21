//
//  OturumAcController.swift
//  deneme
//
//  Created by Umut Yüksel on 21.10.2022.
//

import Foundation
import UIKit

class OturumAcController : UIViewController {
    
    let txtEmail : UITextField = {
        let txt = UITextField()
        txt.placeholder = "Email Adresinizi Giriniz"
        txt.backgroundColor = UIColor(white: 0, alpha: 0.05)
        txt.borderStyle = .roundedRect
        txt.font = UIFont.systemFont(ofSize: 16)
        return txt
    }()
    
    let txtParola : UITextField = {
        let txt = UITextField()
        txt.placeholder = "Parolanız"
        txt.isSecureTextEntry = true
        txt.backgroundColor = UIColor(white: 0, alpha: 0.05)
        txt.borderStyle = .roundedRect
        txt.font = UIFont.systemFont(ofSize: 16)
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
        return btn
    }()
    
    let logoView : UIView = {
        let view = UIView()
        let imgLogo = UIImageView()
        imgLogo.image = UIImage(named: "instagram-isim.png")
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
        
        let attrBaslik = NSMutableAttributedString(string: "Henüz Bir Hesabınız Yok Mu?",attributes: [.font : UIFont.systemFont(ofSize: 16),.foregroundColor : UIColor.lightGray])
        attrBaslik.append(NSMutableAttributedString(string: " Kayıt Ol.",attributes: [.font : UIFont.boldSystemFont(ofSize: 16), .foregroundColor : UIColor.rgbDonustur(red: 20, green: 155, blue: 235)]))
        btn.setAttributedTitle(attrBaslik, for: .normal)
            
        
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(btnKayitOlPressed), for: .touchUpInside)
        return btn
    }()
    
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
