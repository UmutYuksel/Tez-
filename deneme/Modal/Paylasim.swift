//
//  Paylasim.swift
//  deneme
//
//  Created by Umut Yüksel on 28.10.2022.
//

import Firebase

struct Paylasim {
    
    var id : String?
    let kullanici : Kullanici
    let paylasimGoruntuURL : String?
    let goruntuGenislik : Double?
    let goruntuYukseklik : Double?
    let kullaniciID : String?
    let mesaj : String?
    let paylasimTarihi : Timestamp
    var begenildi : Bool = false
    var likeCount : Int
    
    
    init(kullanici : Kullanici, sozlukVerisi : [String : Any]) {
        self.kullanici = kullanici
        self.paylasimGoruntuURL = sozlukVerisi["PaylasimGoruntuURL"] as? String
        self.goruntuGenislik = sozlukVerisi["GoruntuGenislik"] as? Double
        self.goruntuYukseklik = sozlukVerisi["GoruntuYukseklik"] as? Double
        self.kullaniciID = sozlukVerisi["KullaniciID"] as? String
        self.mesaj = sozlukVerisi["Mesaj"] as? String
        self.paylasimTarihi = sozlukVerisi["PaylasimTarihi"] as? Timestamp ?? Timestamp(date: Date())
        self.likeCount = sozlukVerisi["LikeCount"] as? Int ?? 0
        
    }
}
