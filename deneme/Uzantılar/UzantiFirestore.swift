//
//  UzantiFirestore.swift
//  deneme
//
//  Created by Umut Yüksel on 21.11.2022.
//

import Firebase

extension Firestore {
    
    static func kullaniciyiOlustur(kullaniciID : String = "", completion : @escaping (Kullanici) -> ()) {
        
        var kID = ""
        if kullaniciID == "" {
            guard let gecerliKullaniciID = Auth.auth().currentUser?.uid else { return }
            kID = gecerliKullaniciID
        } else {
            kID = kullaniciID
        }
        
        Firestore.firestore().collection("Kullanicilar").document(kID).getDocument { (snapshot, hata) in
            if let hata = hata {
                print("Kullanıcı Bilgileri Getirilemedi : ,\(hata.localizedDescription)")
                return
            }
            guard let kullaniciVerisi = snapshot?.data() else { return }
            let kullanici = Kullanici(kullaniciVerisi: kullaniciVerisi)
            completion(kullanici)
        }
    }
}
