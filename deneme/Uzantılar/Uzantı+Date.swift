//
//  Uzantı+Date.swift
//  deneme
//
//  Created by Umut Yüksel on 21.11.2022.
//

import Foundation

extension Date {
    
    func zamanHesapla() -> String {
        
        let saniyeAl = Int(Date().timeIntervalSince(self))
        
        let dakika = 60
        let saat = 60 * dakika
        let gun = 24 * saat
        let hafta = 7 * gun
        let ay = 4 * hafta
        let yıl = 12 * ay
        
        let oran : Int
        let birim : String
        
        if saniyeAl < dakika {
            oran = saniyeAl
            birim = "Saniye"
        } else if saniyeAl < saat {
            oran = saniyeAl / dakika
            birim = "Dakika"
        } else if saniyeAl < gun {
            oran = saniyeAl / saat
            birim = "Saat"
        } else if saniyeAl < hafta {
            oran = saniyeAl / gun
            birim = "Gün"
        } else if saniyeAl < ay {
            oran = saniyeAl / hafta
            birim = "Hafta"
        } else if saniyeAl < yıl {
            oran = saniyeAl / ay
            birim = "Yıl"
        } else {
            oran = saniyeAl / ay
            birim = "Ay"
        }
        return "\(oran) \(birim) Önce"
    }
}
