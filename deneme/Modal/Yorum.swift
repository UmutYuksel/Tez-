//
//  Yorum.swift
//  tez
//
//  Created by Umut Yüksel on 25.11.2022.
//

import Foundation

struct Yorum {
    
    let yorumMesaji : String
    let kullaniciID : String
    
    init(sozlukVerisi: [String : Any]) {
        self.yorumMesaji = sozlukVerisi["yorumMesajı"] as? String ?? ""
        self.kullaniciID = sozlukVerisi["kullaniciID"] as? String ?? ""
    }
}
