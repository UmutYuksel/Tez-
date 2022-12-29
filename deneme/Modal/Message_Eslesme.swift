//
//  Message_Eslesme.swift
//  tez
//
//  Created by Umut Yüksel on 20.12.2022.
//

import Foundation

struct Takip {
    
    let kullaniciAdi : String
    let profileImageUrl : String
    let kullaniciID : String
    
    init(veri: [String : Any]) {
        self.kullaniciAdi = veri["KullaniciAdi "] as? String ?? ""
        self.profileImageUrl = veri["ProfilGoruntuUrl"] as? String ?? ""
        self.kullaniciID = veri["KullaniciID"] as? String ?? ""
    }
}
