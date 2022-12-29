//
//  EditUserDataController.swift
//  tez
//
//  Created by Umut Yüksel on 28.12.2022.
//

import Foundation
import UIKit
import Firebase
import JGProgressHUD
import SDWebImage
import FirebaseStorage

class EditUserDataController : UITableViewController , UITextFieldDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editNavBar()
        view.backgroundColor = UIColor(white: 0.92, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        kullaniciBilgileriniGetir()
        
    }
    var gecerliKullanici : Kullanici?
    fileprivate func kullaniciBilgileriniGetir() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("Kullanicilar").document(uid).getDocument { (snapshot,error) in
            if let error = error {
                print("Kullanıcı Bilgileri Getirilirken Hata Meydana Geldi",error)
                return
            }
            guard let data = snapshot?.data() else { return }
            self.gecerliKullanici = Kullanici(kullaniciVerisi: data)
            self.getProfileImage()
            self.tableView.reloadData()
        }
    }
    
    fileprivate func getProfileImage() {
        guard let goruntuURL = gecerliKullanici?.profilGoruntuURL, let url = URL(string: goruntuURL) else { return }
        
        SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { goruntuURL, _, _, _, _, _ in
            self.imgProfilePP.setImage(goruntuURL?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    let imgProfilePP : UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(btnImagePPPressed), for: .touchUpInside)
        btn.layer.masksToBounds = true
        btn.layer.borderColor = UIColor.darkGray.cgColor
        btn.layer.borderWidth = 1
        return btn
    }()
    
    @objc fileprivate func btnImagePPPressed() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    let lblProfilePicture : UILabel = {
        let lbl = UILabel()
        lbl.text = "Profil Resmini Düzenle"
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.textColor = UIColor.orangeTint()
        return lbl
    }()
    
    lazy var imgView : UIView = {
        let imgView = UIView()
        
        let imageSize : CGFloat = 90
        
        imgView.addSubview(imgProfilePP)
        
        imgProfilePP.anchor(top: nil, bottom: nil, leading: nil, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: imageSize, height: imageSize)
        imgProfilePP.centerXAnchor.constraint(equalTo: imgView.centerXAnchor).isActive = true
        imgProfilePP.centerYAnchor.constraint(equalTo: imgView.centerYAnchor).isActive = true
        imgProfilePP.layer.cornerRadius = imageSize / 2
        
        imgView.addSubview(lblProfilePicture)
        lblProfilePicture.anchor(top: imgProfilePP.bottomAnchor, bottom: nil, leading: nil, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        lblProfilePicture.centerXAnchor.constraint(equalTo: imgProfilePP.centerXAnchor).isActive = true
        
        imgView.backgroundColor = .white
        return imgView
    }()
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return imgView
        }
        
        let lbl = LabelBaslik()
        switch section {
        case 1 :
            lbl.text = "Adı"
        case 2 :
            lbl.text = "Kullanıcı Adı"
        case 3 :
            lbl.text = "Hakkında"
        default :
            lbl.text = "Hakkında"
        }
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        return lbl
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 135
        }
        return 45
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UpdateProfileCell(style: .default, reuseIdentifier: nil)
        
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Adınız Ve Soyadınız"
            cell.textField.text = gecerliKullanici?.kullaniciIsım
            cell.textField.addTarget(self, action: #selector(txtAdDegisiklikYakala), for: .editingChanged)
            
        case 2:
            cell.textField.placeholder = "Kullanıcı Adınız"
            cell.textField.text = gecerliKullanici?.kullaniciAdi
            cell.textField.addTarget(self, action: #selector(txtKullaniciAdDegisiklikYakala), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Hakkında"
            cell.textField.text = gecerliKullanici?.Bio
            cell.textField.addTarget(self, action: #selector(txtBioDegisiklikYakala), for: .editingChanged)
        default :
            cell.textField.placeholder = "Hakkında"
        }
        return cell
    }
    @objc fileprivate func txtAdDegisiklikYakala(textField : UITextField) {
        self.gecerliKullanici?.kullaniciIsım = textField.text ?? ""
    }
    
    @objc fileprivate func txtKullaniciAdDegisiklikYakala(textField : UITextField) {
        self.gecerliKullanici?.kullaniciAdi = textField.text ?? ""
    }
    @objc fileprivate func txtBioDegisiklikYakala(textField : UITextField) {
        self.gecerliKullanici?.Bio = textField.text ?? ""
    }
    
    fileprivate func editNavBar() {
        navigationItem.title = "Profili Düzenle"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "İptal", style: .plain, target: self, action: #selector(btnCancelPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Güncelle", style: .plain, target: self, action: #selector(btnUpdatePressed))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.orangeTint()
        navigationItem.rightBarButtonItem?.tintColor = UIColor.orangeTint()
    }
    
    @objc fileprivate func btnCancelPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func btnUpdatePressed() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let veriler : [String : Any] = [
            "IsımSoyisim" : gecerliKullanici?.kullaniciIsım ?? "",
            "ProfilGoruntuUrl" : gecerliKullanici?.profilGoruntuURL ?? "",
            "Biyografi" : gecerliKullanici?.Bio ?? "",
            "KullaniciAdi " : gecerliKullanici?.kullaniciAdi ?? ""]
        
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Bilgileriniz Güncelleniyor"
        hud.show(in: view)
        Firestore.firestore().collection("Kullanicilar").document(uid).updateData(veriler) { (hata) in
            if let hata = hata {
                print("Kullanıcı Verileri Kayıt Edilemedi",hata)
                return
            }
            print("Kullanıcı Verileri Başarılı Bir Şekilde Kayıt Edildi")
            self.tableView.reloadData()
            hud.dismiss(afterDelay: 1)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

}

extension EditUserDataController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let imgSecilen = info[.originalImage] as? UIImage
        self.imgProfilePP.setImage(imgSecilen?.withRenderingMode(.alwaysOriginal), for: .normal)
        imgProfilePP.imageView?.contentMode = .scaleAspectFill
        imgProfilePP.layer.cornerRadius = imgProfilePP.frame.width / 2
        imgProfilePP.layer.masksToBounds = true
        imgProfilePP.layer.borderColor = UIColor.darkGray.cgColor
        imgProfilePP.layer.borderWidth = 1
        dismiss(animated: true, completion: nil)
        
        let goruntuAdi = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/ProfilFotografları/\(goruntuAdi)")
        let goruntuData = self.imgProfilePP.imageView?.image?.jpegData(compressionQuality: 1) ?? Data()
        guard let oturumKID = Auth.auth().currentUser?.uid else { return }
        
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Görüntü Yükleniyor..."
        hud.show(in: view)
        
        ref.putData(goruntuData, metadata: nil) { (sonuc , hata) in
            
            if let hata = hata {
                hud.dismiss(animated: true)
                print("Görüntü Kaydedilemedi:",hata)
                return
            }
            print("Görüntü Başarı İle Upload Edildi")
            
            ref.downloadURL { (url , hata) in
                
                if let hata = hata {
                    print("Görüntünün URL Adresi Alınamadı", hata)
                    return
                }
                print("Upload Edilen Görüntünün Url Adresi :\(url?.absoluteString ?? "Link Yok")")
            
                let eklenecekVeri = ["ProfilGoruntuUrl" : url?.absoluteString ?? ""]
                
                Firestore.firestore().collection("Kullanicilar").document(oturumKID)
                    .updateData(eklenecekVeri) { (hata) in
                        
                        if let hata = hata {
                            print("Kullanıcı Verileri FireStore'a Kaydedilemedi",hata)
                            return
                        }
                        print("Kullanıcı Verileri FireStore'a Kaydedildi")
                        hud.dismiss(afterDelay: 1)
                }
            }
        }
    }
}

class LabelBaslik : UILabel { 
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 15, dy: 0))
    }
}
