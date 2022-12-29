//
//  MessagesController.swift
//  tez
//
//  Created by Umut Yüksel on 14.12.2022.
//

import UIKit
import Firebase

class MessagesController : ListeController<MessageCell,Message> {
    
    fileprivate lazy var navBar = MessageNavBar(eslesme: eslesme)
    
    fileprivate let navBarHeight : CGFloat = 125
    fileprivate let eslesme : Takip
    
    init(eslesme: Takip) {
        self.eslesme = eslesme
        super.init()
    }
    
    var gecerliKullanici : Kullanici?
    
    fileprivate func getCurrentUser() {
        let gecerliKullaniciID = Auth.auth().currentUser?.uid ?? ""
        
        Firestore.firestore().collection("Kullanicilar").document(gecerliKullaniciID).getDocument { (snapshot,hata) in
            if let hata = hata {
                print("Geçerli Kullanıcının Bilgileri Getirilemedi :",hata)
                return
            }
            let kullaniciVerisi = snapshot?.data() ?? [:]
            self.gecerliKullanici = Kullanici(kullaniciVerisi: kullaniciVerisi)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(setKeyboardType), name: UIResponder.keyboardDidShowNotification, object: nil)
        collectionView.keyboardDismissMode = .interactive
        navBar.btnBack.addTarget(self, action: #selector(btnBackPressed), for: .touchUpInside)
        
        getMessages()
        gorunumuOlustur()
        getCurrentUser()
    }
    
    class KeyboardView : UIView {
        
        let txtMessage = UITextView()
        let btnSend = UIButton(baslik: "Gönder", baslikRenk: .black, baslikFont: .boldSystemFont(ofSize: 17))
        let lblPlaceholder = UILabel(text: "Mesaj yaz...", font: .systemFont(ofSize: 16), textColor: .lightGray)
        
        override var intrinsicContentSize: CGSize {
            return .zero
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .white
            golgeEkle(opacity: 0.1, yaricap: 8, offset: .init(width: 0, height: -9), renk: .lightGray)
            autoresizingMask = .flexibleHeight
            txtMessage.text = ""
            txtMessage.isScrollEnabled = false
            txtMessage.font = .systemFont(ofSize: 16)
            
            NotificationCenter.default.addObserver(self, selector: #selector(txtMessageChange), name: UITextView.textDidChangeNotification, object: nil)
            btnSend.boyutlandir(.init(width: 65, height: 65))
            yatayStackViewOlustur(txtMessage,
                                           btnSend.boyutlandir(.init(width: 65, height: 65)),
                                           alignment: .center).withMarging(.init(top: 0, left: 15, bottom: 0, right: 15))
            addSubview(lblPlaceholder)
            lblPlaceholder.anchor(top: nil, bottom: nil, leading: leadingAnchor, trailing: btnSend.leadingAnchor,padding: .init(top: 0, left: 20, bottom: 0, right: 0))
            lblPlaceholder.centerYAnchor.constraint(equalTo: btnSend.centerYAnchor).isActive = true
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
        
        @objc fileprivate func txtMessageChange() {
            lblPlaceholder.isHidden = txtMessage.text.count != 0
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    lazy var messageInputView : KeyboardView =  {
        let messageInputView = KeyboardView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
        
        messageInputView.btnSend.addTarget(self, action: #selector(btnSendPressed), for: .touchUpInside)
        
        return messageInputView
    }()
    
    @objc fileprivate func btnSendPressed() {
        print(messageInputView.txtMessage.text ?? "Veri Yok")
        saveMessageFS()
        saveLastMessageFS()
        
    }
    
    fileprivate func saveLastMessageFS() {
        
        guard let gecerliKID = Auth.auth().currentUser?.uid else { return }
        
        let lastMessageData = [
            "Message" : messageInputView.txtMessage.text ?? "",
            "KullaniciAdi " : eslesme.kullaniciAdi,
            "KullaniciID" : eslesme.kullaniciID,
            "ProfilGoruntuUrl" : eslesme.profileImageUrl] as [String : Any]
        
        
        Firestore.firestore().collection("Mesajlar").document(gecerliKID).collection("Last_Messages").document(eslesme.kullaniciID).setData(lastMessageData) { (hata) in
            if let hata = hata {
                print("Hata! Gönderilen Mesaj Son Mesaj Olarak Eklenemedi :",hata)
            }
            print("Gönderilen Mesaj Son Mesaj Olarak Kaydedildi.")
            }
        
        // Son Mesaj Verisini Mesajlaştığımız kişi için'de kayıt edilmesi
        guard let gecerliKullanici = self.gecerliKullanici else { return }
        let otherMessageData = [
            "Message" : messageInputView.txtMessage.text ?? "",
            "KullaniciAdi " : gecerliKullanici.kullaniciAdi,
            "KullaniciID" : gecerliKullanici.kullaniciID,
            "ProfilGoruntuUrl" : gecerliKullanici.profilGoruntuURL] as [String : Any]
        
        Firestore.firestore().collection("Mesajlar").document(eslesme.kullaniciID).collection("Last_Messages").document(gecerliKID).setData(otherMessageData) { (hata) in
            if let hata = hata {
                print("Hata! Gönderilen Mesaj Karşıdaki Kullanıcı İçin \"SON MESAJ\" Olarak Eklenemedi :",hata)
                return
            }
            print("Gönderilen Mesaj Karşıdaki Kullanıcı İçin \"SON MESAJ\" Olarak Kaydedildi")
        }
        }
        
    fileprivate func saveMessageFS() {
        guard let gecerliKID = Auth.auth().currentUser?.uid else { return }
        
        let collection = Firestore.firestore().collection("Mesajlar").document(gecerliKID).collection(eslesme.kullaniciID)
        let addedData = ["Message" : messageInputView.txtMessage.text ?? "",
                         "GondericiID" : gecerliKID,
                         "AliciID" : eslesme.kullaniciID,
                         "Timestamp" : Timestamp(date: Date())] as [String : Any]
        collection.addDocument(data: addedData) { (hata) in
            if let hata = hata {
                print("Mesaj Gönderilirken Hata Oluştu :",hata)
            }
            print("Mesaj Başarıyla Firestore'a Kaydedildi.")
            self.messageInputView.txtMessage.text = nil
            self.messageInputView.lblPlaceholder.isHidden = false
        }
        
        let collection2 = Firestore.firestore().collection("Mesajlar").document(eslesme.kullaniciID).collection(gecerliKID)
        collection2.addDocument(data: addedData) { (hata) in
            if let hata = hata {
                print("Mesajlar Gönderilirken Hata Oluştur :",hata)
                return
            }
            print("Mesaj Başarıyla Firestore'a Kaydedildi.")
            self.messageInputView.txtMessage.text = nil
            self.messageInputView.lblPlaceholder.isHidden = false
        }
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return messageInputView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    
    @objc fileprivate func setKeyboardType() {
        self.collectionView.scrollToItem(at: [0,veriler.count-1], at: .bottom, animated: true)
    }
    
    fileprivate func getMessages() {
     
        print("Mesajlar Getiriliyor")
        
        guard let gecerliKID = Auth.auth().currentUser?.uid else { return }
        
        let sorgu = Firestore.firestore().collection("Mesajlar").document(gecerliKID).collection(eslesme.kullaniciID).order(by: "Timestamp")
        
        sorgu.addSnapshotListener { (snapshot,hata) in
            if let hata = hata {
                print("Mesajlar Getirilirken Hata Meydana Geldi :",hata)
                return
            }
            snapshot?.documentChanges.forEach({ (degisiklik) in
                if degisiklik.type == .added {
                    let messageVerisi = degisiklik.document.data()
                    self.veriler.append(.init(messageData: messageVerisi))
                }
            })
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: [0,self.veriler.count-1], at: .bottom, animated: true)
        }
        
    }
    
    fileprivate func gorunumuOlustur() {
        view.addSubview(navBar)
        navBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,boyut: .init(width: 0, height: navBarHeight))
        collectionView.contentInset.top = navBarHeight
        collectionView.contentInset.bottom = 65
        
        let statusBar = UIView(arkaPlanRenk: .white)
        view.addSubview(statusBar)
        statusBar.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        
        let statusBar2 = UIView(arkaPlanRenk: .white)
        view.addSubview(statusBar2)
        statusBar2.anchor(top: collectionView.bottomAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        
        collectionView.verticalScrollIndicatorInsets.top = navBarHeight
        collectionView.verticalScrollIndicatorInsets.bottom = 65
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    @objc fileprivate func btnBackPressed() {
        navigationController?.popViewController(animated: true)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}

extension MessagesController : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let tahminiCell = MessageCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
        
        tahminiCell.veri = self.veriler[indexPath.item]
        
        tahminiCell.layoutIfNeeded()
        
        let tahminiBoyut = tahminiCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
        
        return .init(width: view.frame.width, height: tahminiBoyut.height)
    }
}
