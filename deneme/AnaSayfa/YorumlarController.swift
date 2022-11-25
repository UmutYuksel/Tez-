//
//  CommentsController.swift
//  tez
//
//  Created by Umut Yüksel on 25.11.2022.
//

import UIKit
import Firebase

class YorumlarController : UICollectionViewController {
    
    var secilenPaylasim : Paylasim?

    let yorumcellID = "yorumcellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Yorumlar"
        
        collectionView.backgroundColor = .yellow
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -80, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -80, right: 0)
        collectionView.register(YorumCell.self, forCellWithReuseIdentifier: yorumcellID)
        
        yorumlarıGetir()
    }
    
    var yorumlar = [Yorum]()
    
    fileprivate func yorumlarıGetir() {
        guard let paylasimID = self.secilenPaylasim?.id else { return }
        
        Firestore.firestore().collection("Yorumlar").document(paylasimID).collection("Eklenen_Yorumlar").addSnapshotListener { (snapshot , hata)  in
            if let hata = hata {
                print("Yorumları Getirilirken Hata Meydana Geldi",hata.localizedDescription)
            }
            snapshot?.documentChanges.forEach({ (documentChange) in
                let sozlukVerisi = documentChange.document.data()
                let yorum = Yorum(sozlukVerisi: sozlukVerisi)
                self.yorumlar.append(yorum)
                self.collectionView.reloadData()
                print(yorum.yorumMesaji, " - ", yorum.kullaniciID)
            })
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return yorumlar.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let hucre = collectionView.dequeueReusableCell(withReuseIdentifier: yorumcellID, for: indexPath) as! YorumCell
        hucre.yorum = yorumlar[indexPath.row]
        return hucre
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    lazy var  containerView : UIView? = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 120, height: 80)
        let btnCommentSend = UIButton(type: .system)
        btnCommentSend.setTitle("Gönder", for: .normal)
        btnCommentSend.setTitleColor(.black, for: .normal)
        btnCommentSend.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        containerView.addSubview(btnCommentSend)
        
        btnCommentSend.anchor(top: containerView.safeAreaLayoutGuide.topAnchor, bottom: containerView.safeAreaLayoutGuide.bottomAnchor, leading: nil, trailing: containerView.safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 15, paddingRight: 0, width: 80, height: 0)
        btnCommentSend.addTarget(self, action: #selector(btnCommentSendPressed), for: .touchUpInside)
        
        containerView.addSubview(txtComment)
        
        txtComment.anchor(top: containerView.safeAreaLayoutGuide.topAnchor, bottom: containerView.safeAreaLayoutGuide.bottomAnchor, leading: containerView.safeAreaLayoutGuide.leadingAnchor, trailing: btnCommentSend.leadingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        return containerView
    }()
    
    let txtComment : UITextField = {
        let txt = UITextField()
        txt.placeholder = "Yorumunuzu Girin..."
        return txt
    }()
    
    @objc fileprivate func btnCommentSendPressed() {
        
        if let yorum = txtComment.text, yorum.isEmpty {
            return
        }
        
        guard let gecerliKullaniciID = Auth.auth().currentUser?.uid else { return }
        
        let paylasimID = self.secilenPaylasim?.id ?? ""
        let eklenecekDeger = ["yorumMesajı" : txtComment.text ?? "",
                              "eklenmeTarihi" : Date().timeIntervalSince1970,
                              "kullaniciID" : gecerliKullaniciID] as [String : Any]
        
        Firestore.firestore().collection("Yorumlar").document(paylasimID).collection("Eklenen_Yorumlar").document().setData(eklenecekDeger) { (hata) in
            if let hata = hata {
                print("Yorum Eklenirken Hata Meydana Geldi",hata.localizedDescription)
                return
            }
            print("Yorum Başarı İle Eklendi")
            self.txtComment.text = ""
        }
        
        
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}

extension YorumlarController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 65)
    }
}

