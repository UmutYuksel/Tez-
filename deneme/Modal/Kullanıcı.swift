//
//  Kullanıcı.swift
//  deneme
//
//  Created by Umut Yüksel on 17.10.2022.
//

import Foundation

struct Kullanici {
    
    let kullaniciAdi : String
    let kullaniciID : String
    let profilGoruntuURL : String
    init(kullaniciVerisi : [String : Any]) {
        
        self.kullaniciAdi = kullaniciVerisi["KullaniciAdi"] as? String ?? ""
        self.kullaniciID = kullaniciVerisi["KullaniciID"] as? String ?? ""
        self.profilGoruntuURL = kullaniciVerisi["ProfilGoruntuUrl"] as? String ?? ""
    }
}
