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
    
    let kullaniciAdi : String
    let kullaniciID : String
    let profilGoruntuURL : String
    let takipEdiyor : String
    let takipci : String
    var takipEdiyorCount : Int
    var takipciCount : Int
    
    init(kullaniciVerisi : [String : Any]) {
        
        self.kullaniciAdi = kullaniciVerisi["KullaniciAdi "] as? String ?? ""
        self.kullaniciID = kullaniciVerisi["KullaniciID"] as? String ?? ""
        self.profilGoruntuURL = kullaniciVerisi["ProfilGoruntuUrl"] as? String ?? ""
        self.takipEdiyor = kullaniciVerisi["TakipEdiyor"] as? String ?? "0"
        self.takipci = kullaniciVerisi["Takipci"] as? String ?? "0"
        self.takipEdiyorCount = kullaniciVerisi["TakipEdiyorSayisi"] as? Int ?? 0
        self.takipciCount = kullaniciVerisi["TakipciSayisi"] as? Int ?? 0
    }
}
