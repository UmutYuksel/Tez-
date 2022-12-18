//
//  Yorum.swift
//  tez
//
//  Created by Umut Yüksel on 25.11.2022.
//

import Foundation

struct Yorum {
    
    let kullanici : Kullanici
    let yorumMesaji : String
    let kullaniciID : String
    
    
    init(kullanici : Kullanici, sozlukVerisi: [String : Any]) {
        
        self.kullanici = kullanici
        self.yorumMesaji = sozlukVerisi["yorumMesajı"] as? String ?? ""
        self.kullaniciID = sozlukVerisi["kullaniciID"] as? String ?? ""
    }
}
