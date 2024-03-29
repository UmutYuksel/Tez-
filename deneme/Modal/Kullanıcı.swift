//
//  Kullanıcı.swift
//  deneme
//
//  Created by Umut Yüksel on 17.10.2022.
//

import Foundation
import Firebase
import FirebaseStorage

struct Kullanici {
    
    var kullaniciAdi : String
    var kullaniciID : String
    var kullaniciIsım : String
    let profilGoruntuURL : String
    let takipEdiyor : String
    let takipci : String
    var takipEdiyorCount : Int
    var takipciCount : Int
    var paylasimCount : Int
    var Bio : String
    var eMail : String
    var parola : String
    
    init(kullaniciVerisi : [String : Any]) {
        
        self.kullaniciAdi = kullaniciVerisi["KullaniciAdi "] as? String ?? ""
        self.kullaniciID = kullaniciVerisi["KullaniciID"] as? String ?? ""
        self.kullaniciIsım = kullaniciVerisi["IsımSoyisim"] as? String ?? ""
        self.profilGoruntuURL = kullaniciVerisi["ProfilGoruntuUrl"] as? String ?? ""
        self.takipEdiyor = kullaniciVerisi["TakipEdiyor"] as? String ?? "0"
        self.takipci = kullaniciVerisi["Takipci"] as? String ?? "0"
        self.takipEdiyorCount = kullaniciVerisi["TakipEdiyorSayisi"] as? Int ?? 0
        self.takipciCount = kullaniciVerisi["TakipciSayisi"] as? Int ?? 0
        self.paylasimCount = kullaniciVerisi["PaylasimSayisi"] as? Int ?? 0
        self.Bio = kullaniciVerisi["Biyografi"] as? String ?? ""
        self.eMail = kullaniciVerisi["E-Mail"] as? String ?? ""
        self.parola = kullaniciVerisi["Parola"] as? String ?? ""
        
    }
}
