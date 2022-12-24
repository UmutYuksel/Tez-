//
//  LastMessagesController.swift
//  tez
//
//  Created by Umut Yüksel on 18.12.2022.
//

import UIKit
import Firebase



class LastMessageCell : ListeCell<LastMessage> {
    
    let imgProfile = UIImageView(image: UIImage(named: "user-selected.png"),contentMode: .scaleToFill)
    let lblUserName = UILabel(text: "", font: .boldSystemFont(ofSize: 19))
    let lblLastMessage = UILabel(text: "", font: .systemFont(ofSize: 16), textColor: .lightGray,numberofLines: 2)
    
    override func viewOlustur() {
        super.viewOlustur()
        
        let imgDimension : CGFloat = 60
        imgProfile.layer.cornerRadius = imgDimension / 2
        
        
        yatayStackViewOlustur(imgProfile.boyutlandir(.init(width: imgDimension, height: imgDimension)),
                              (stackViewOlustur(lblUserName,lblLastMessage,spacing: 3)),spacing: 20,alignment: .center)
        .padLeft(10).padRight(10)
        
        ayracEkle(leadingAnchor: lblUserName.leadingAnchor)
    }
    
    
    override var veri: LastMessage! {
        didSet {
            
            lblUserName.text = veri.userName
            lblLastMessage.text = veri.message
            imgProfile.sd_setImage(with: URL(string: veri.profileIMG))
        }
    }
}


class LastMessagesController : ListeController<LastMessageCell,LastMessage>, UICollectionViewDelegateFlowLayout{
    
    var lastMessageData = [String : LastMessage]()
    
    fileprivate func getLastMessages() {
        guard let gecerliKID = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("Mesajlar").document(gecerliKID).collection("Last_Messages").addSnapshotListener { (querySnapshot,hata) in
            if let hata = hata {
                print("Son Mesaj Getirilirken Hata Oluştu :",hata)
                return
            }
            querySnapshot?.documentChanges.forEach({ (degisiklik) in
                if degisiklik.type == .added || degisiklik.type == .modified {
                    let addedLastMessage = degisiklik.document.data()
                    let lastMessage = LastMessage(veri: addedLastMessage)
                    self.lastMessageData[lastMessage.userID] = lastMessage // Eğer güncelleme yapılmış ise yeni veri eklenmez var olan veri güncellenir
                }
                
                if degisiklik.type == .removed {
                    let messageData = degisiklik.document.data()
                    
                    let removeMessage = LastMessage(veri: messageData)
                    self.lastMessageData.removeValue(forKey: removeMessage.userID)
                }
            })
            self.resetData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let lastMessage = self.veriler[indexPath.row]
        
        let messageKData = ["KullaniciID" : lastMessage.userID,
                            "KullaniciAdi " : lastMessage.userName,
                            "ProfilGoruntuUrl": lastMessage.profileIMG]
        let takip = Takip(veri: messageKData)
        
        let messageController = MessagesController(eslesme: takip)
        navigationController?.pushViewController(messageController, animated: true)
        
    }
    
    fileprivate func resetData() {
        
        let lastMessageArray = Array(lastMessageData.values)
        veriler = lastMessageArray.sorted(by: { (message1,message2) -> Bool in
            return message1.timeStamp.compare(message2.timeStamp) == .orderedDescending
        })
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 100)
    }
    
    let navBar = LastMessageNavBar()
    fileprivate let navBarHeight : CGFloat = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar.btnBack.addTarget(self, action: #selector(btnBackPressed), for: .touchUpInside)
        navBar.btnNewMessage.addTarget(self, action: #selector(btnNewMessagePressed), for: .touchUpInside)
        collectionView.backgroundColor = .white
        gorunmuOlustur()
        getLastMessages()
        
        veriler = []
        
    }
    
    fileprivate func gorunmuOlustur() {
        view.addSubview(navBar)
        navBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,boyut: .init(width: 0, height: navBarHeight))
        collectionView.contentInset.top = navBarHeight
        
        let statusBar = UIView(arkaPlanRenk: .white)
        view.addSubview(statusBar)
        statusBar.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        
        collectionView.verticalScrollIndicatorInsets.top = navBarHeight
    }
    
    @objc fileprivate func btnBackPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func btnNewMessagePressed() {
        let newMessageController = NewMessageController()
        navigationController?.pushViewController(newMessageController, animated: true)
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
    
}
