//
//  LastMessage.swift
//  tez
//
//  Created by Umut Yüksel on 20.12.2022.
//

import Foundation
import Firebase

struct LastMessage {
    
    let message : String
    let userID : String
    let userName : String
    let profileIMG : String
    let timeStamp : Timestamp
    
    init(veri : [String : Any]) {
        self.message = veri["Message"] as? String ?? ""
        self.userID = veri["KullaniciID"] as? String ?? ""
        self.userName = veri["KullaniciAdi "] as? String ?? ""
        self.profileIMG = veri["ProfilGoruntuUrl"] as? String ?? ""
        self.timeStamp = veri["Timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}

