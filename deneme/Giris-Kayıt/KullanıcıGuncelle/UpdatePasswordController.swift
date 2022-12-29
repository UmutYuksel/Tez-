//
//  UpdatePasswordController.swift
//  tez
//
//  Created by Umut Yüksel on 29.12.2022.
//

import Foundation
import UIKit
import Firebase
import JGProgressHUD

class UpdatePasswordController : UIViewController {
    
    let txtPassword : UITextField = {
        let txt = UITextField()
        txt.placeholder = "Lütfen Parolanızı Giriniz"
        txt.backgroundColor = UIColor(white: 0, alpha: 0.05)
        txt.borderStyle = .roundedRect
        txt.font = UIFont.systemFont(ofSize: 16)
        txt.addTarget(self, action: #selector(veriDegisimi), for: .editingChanged)
        return txt
    }()
    let txtNewPassword : UITextField = {
        let txt = UITextField()
        txt.placeholder = "Lütfen Yeni Parolanızı Giriniz"
        txt.backgroundColor = UIColor(white: 0, alpha: 0.05)
        txt.borderStyle = .roundedRect
        txt.isSecureTextEntry = true
        txt.font = UIFont.systemFont(ofSize: 16)
        txt.addTarget(self, action: #selector(veriDegisimi), for: .editingChanged)
        return txt
    }()
    
    @objc fileprivate func veriDegisimi() {
        let formGecerliMi = (txtPassword.text?.count ?? 0) > 0 && (txtNewPassword.text?.count ?? 0) > 0
        if formGecerliMi {
            btnResetPassword.isEnabled = true
            btnResetPassword.backgroundColor = UIColor.orangeTint()
        } else {
            btnResetPassword.isEnabled = false
            btnResetPassword.backgroundColor = UIColor.lightGray
        }
    }
    let btnResetPassword : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Parolayı Sıfırla", for: .normal)
        btn.backgroundColor = UIColor.lightGray
        btn.layer.cornerRadius = 6
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.setTitleColor(.white, for: .normal)
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(btnResetPasswordPressed), for: .touchUpInside)
        return btn
    }()
    @objc fileprivate func btnResetPasswordPressed() {
        let db = Firestore.firestore()
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        guard let currentUser = Auth.auth().currentUser else {return}
        db.collection("Kullanicilar").document(currentUserID).updateData(["Parola" : txtNewPassword.text])
        if txtNewPassword.text != txtPassword.text {
            currentUser.updatePassword(to: txtNewPassword.text!) { error in
                if let error = error {
                    print(error)
                }
                    let hud = JGProgressHUD(style: .light)
                    hud.textLabel.text = "Parola Güncelleme Başarılı\nLütfen Tekrardan Giriş Yapınız..."
                    hud.show(in: self.view)
                hud.dismiss(afterDelay: 2, animated: true)
            }
        } else {
            let hud = JGProgressHUD(style: .light)
            hud.textLabel.text = "Lütfen Mevcut Parolanızdan Farklı Bir Parola Yazınız..."
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 1.5)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    let logoView : UIView = {
        let view = UIView()
        let lblPassword = UILabel()
        lblPassword.text = "Parola Güncelleme"
        lblPassword.textColor = .white
        view.addSubview(lblPassword)
        lblPassword.anchor(top: nil, bottom: nil, leading: nil, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 37)
        lblPassword.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lblPassword.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        let btnBack = UIButton(image: UIImage(named: "back-arrow-p.png")!.withRenderingMode(.alwaysOriginal))
        view.addSubview(btnBack)
        btnBack.anchor(top: nil, bottom: nil, leading: view.leadingAnchor, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 15, paddingRight: 0, width: 0, height: 0)
        btnBack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        btnBack.addTarget(self, action: #selector(btnBackPressed), for: .touchUpInside)
        view.backgroundColor = UIColor.orangeTint()
        return view
    }()
    
    @objc fileprivate func btnBackPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(logoView)
        logoView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 100)
        girisGorunumOlustur()
    }
    
    func girisGorunumOlustur() {
        let stackView = UIStackView(arrangedSubviews: [txtPassword,txtNewPassword,btnResetPassword])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.anchor(top: logoView.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 40, paddingBottom: 0, paddingLeft: 40, paddingRight: -40, width: 0, height: 185)
        let statusBar = UIView(arkaPlanRenk: UIColor.orangeTint())
        view.addSubview(statusBar)
        statusBar.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.isNavigationBarHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.isNavigationBarHidden = true
    }
}
