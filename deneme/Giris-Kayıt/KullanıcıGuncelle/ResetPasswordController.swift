//
//  ResetPasswordController.swift
//  tez
//
//  Created by Umut Yüksel on 28.12.2022.
//

import Foundation
import UIKit
import Firebase
import JGProgressHUD

class ResetPasswordController : UIViewController {
    
    let txtEmail : UITextField = {
        let txt = UITextField()
        txt.placeholder = "Email adresinizi giriniz"
        txt.backgroundColor = UIColor(white: 0, alpha: 0.05)
        txt.borderStyle = .roundedRect
        txt.font = UIFont.systemFont(ofSize: 16)
        txt.addTarget(self, action: #selector(veriDegisimi), for: .editingChanged)
        return txt
    }()
    @objc fileprivate func veriDegisimi() {
        let formGecerliMi = (txtEmail.text?.count ?? 0) > 0
        if formGecerliMi {
            btnResetPassword.isEnabled = true
            btnResetPassword.backgroundColor = UIColor.rgbDonustur(red: 20, green: 155, blue: 235)
        } else {
            btnResetPassword.isEnabled = false
            btnResetPassword.backgroundColor = UIColor.rgbDonustur(red: 150, green: 205, blue: 245)
        }
    }
    let btnResetPassword : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Şifre Sıfırlama Bağlantısı Gönder", for: .normal)
        btn.backgroundColor = UIColor.rgbDonustur(red: 150, green: 205, blue: 245)
        btn.layer.cornerRadius = 6
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.setTitleColor(.white, for: .normal)
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(btnResetPasswordPressed), for: .touchUpInside)
        return btn
    }()
    @objc fileprivate func btnResetPasswordPressed() {
        let auth = Auth.auth()
        
        auth.sendPasswordReset(withEmail: txtEmail.text!) { (error) in
            if let error = error {
                let errorHud = JGProgressHUD(style: .light)
                errorHud.textLabel.text = "Şifre Sıfırlama İsteği Gerçekleşmedi"
                errorHud.show(in: self.view)
                errorHud.dismiss(afterDelay: 2)
                return
            }
            let successHud = JGProgressHUD(style: .light)
            successHud.textLabel.text = "Şifre Sıfırlama İsteği \nE-Mail Adresinize Gönderildi"
            successHud.show(in: self.view)
            successHud.dismiss(afterDelay: 2)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    let logoView : UIView = {
        let view = UIView()
        let imgLogo = UIImageView()
        imgLogo.image = UIImage(named: "food-c.png")
        view.addSubview(imgLogo)
        imgLogo.contentMode = .scaleAspectFill
        imgLogo.anchor(top: nil, bottom: nil, leading: nil, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 75, height: 37)
        imgLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imgLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        let btnBack = UIButton(image: UIImage(named: "back-button.png")!.withRenderingMode(.alwaysOriginal))
        view.addSubview(btnBack)
        btnBack.anchor(top: nil, bottom: nil, leading: view.leadingAnchor, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 15, paddingRight: 0, width: 0, height: 0)
        btnBack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        btnBack.addTarget(self, action: #selector(btnBackPressed), for: .touchUpInside)
        view.backgroundColor = UIColor.rgbDonustur(red: 0, green: 120, blue: 175)
        return view
    }()
    
    @objc fileprivate func btnBackPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(logoView)
        logoView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 100)
        girisGorunumOlustur()
    }
    
    func girisGorunumOlustur() {
        let stackView = UIStackView(arrangedSubviews: [txtEmail,btnResetPassword])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.anchor(top: logoView.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 40, paddingBottom: 0, paddingLeft: 40, paddingRight: -40, width: 0, height: 120)
        let statusBar = UIView(arkaPlanRenk: .rgb(red: 0, green: 120, blue: 175))
        view.addSubview(statusBar)
        statusBar.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
    }
}
