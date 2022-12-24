//
//  Message.swift
//  tez
//
//  Created by Umut Yüksel on 20.12.2022.
//

import Foundation
import Firebase

struct Message {
    let message : String
    let messageIsMine : Bool
    
    let gondericiID : String
    let aliciID : String
    let timeStamp : Timestamp
    
    init(messageData : [String : Any]) {
        
        self.message = messageData["Message"] as? String ?? ""
        self.gondericiID = messageData["GondericiID"] as? String ?? ""
        self.aliciID = messageData["AliciID"] as? String ?? ""
        self.timeStamp = messageData["Timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.messageIsMine = Auth.auth().currentUser?.uid == self.gondericiID
     }
}
