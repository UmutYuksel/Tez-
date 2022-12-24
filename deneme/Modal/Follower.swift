//
//  Follower.swift
//  tez
//
//  Created by Umut Yüksel on 24.12.2022.
//

import Foundation

struct Follower {
        
    let kullaniciAdi : String
    let profileImageUrl : String
    let kullaniciID : String
    let takipciSayisi : Int
   
    init(veri: [String : Any]) {
        self.kullaniciAdi = veri["KullaniciAdi "] as? String ?? ""
        self.profileImageUrl = veri["ProfilGoruntuUrl"] as? String ?? ""
        self.kullaniciID = veri["KullaniciID"] as? String ?? ""
        self.takipciSayisi = veri["TakipciSayisi"] as! Int
    }
}
