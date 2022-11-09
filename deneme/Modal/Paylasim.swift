//
//  Paylasim.swift
//  deneme
//
//  Created by Umut Yüksel on 28.10.2022.
//

import Firebase

struct Paylasim {
    
    let paylasimGoruntuURL : String?
    let goruntuGenislik : Double?
    let goruntuYukseklik : Double?
    let kullaniciID : String?
    let mesaj : String?
    let paylasimTarihi : Timestamp?
    
    init(sozlukVerisi : [String : Any]) {
        self.paylasimGoruntuURL = sozlukVerisi["PaylasimGoruntuURL"] as? String
        self.goruntuGenislik = sozlukVerisi["GoruntuGenislik"] as? Double
        self.goruntuYukseklik = sozlukVerisi["GoruntuYukseklik"] as? Double
        self.kullaniciID = sozlukVerisi["KullaniciID"] as? String
        self.mesaj = sozlukVerisi["Mesaj"] as? String
        self.paylasimTarihi = sozlukVerisi["PaylasimTarihi"] as? Timestamp
    }
}
