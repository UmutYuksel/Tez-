//
//  MessagesController.swift
//  tez
//
//  Created by Umut Yüksel on 14.12.2022.
//

import UIKit
import Firebase

struct Message {
    let text : String
    let messageIsMine : Bool
}

class MessageCell : ListeCell<Message> {
    
    let messageContainer = UIView(arkaPlanRenk: UIColor.messageGray())
    
    
    let txtMessage : UITextView = {
        let txt = UITextView()
        txt.backgroundColor = .clear
        txt.font = .systemFont(ofSize: 20)
        txt.isScrollEnabled = false
        txt.isEditable = false
        return txt
    }() // Mesajları gösterir
    
    override var veri : Message! {
        didSet {
            txtMessage.text = veri.text
            let right = true
            if veri.messageIsMine {
                messageConstraint.trailing?.isActive = true
                messageConstraint.leading?.isActive = false
                messageContainer.backgroundColor = UIColor.messageGreen()
                txtMessage.textColor = .white
            } else {
                messageConstraint.trailing?.isActive = false
                messageConstraint.leading?.isActive = true
                messageContainer.backgroundColor = UIColor.messageGray()
                txtMessage.textColor = .black
            }
        }
    }
    var messageConstraint : AnchorConstraints!
    override func viewOlustur() {
        super.viewOlustur()
        
        addSubview(messageContainer)
        messageContainer.layer.cornerRadius = 15
        messageConstraint = messageContainer.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor)
        messageConstraint.leading?.constant = 20
        messageConstraint.trailing?.isActive = false
        messageConstraint.trailing?.constant = -20
        
        messageContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 260).isActive = true
        messageContainer.addSubview(txtMessage)
        txtMessage.doldurSuperView(padding: .init(top: 5, left: 13, bottom: 5, right: 13))
    }
}



class MessagesController : ListeController<MessageCell,Message> {
    
    fileprivate lazy var navBar = MessageNavBar(eslesme: eslesme)
    
    fileprivate let navBarHeight : CGFloat = 125
    fileprivate let eslesme : Takip
    
    init(eslesme: Takip) {
        self.eslesme = eslesme
        super.init()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar.btnBack.addTarget(self, action: #selector(btnBackPressed), for: .touchUpInside)
        
        veriler = [
            .init(text: "Udemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy KursuUdemy Kursu",messageIsMine: true),
            .init(text: "Udemy Kursu",messageIsMine: false),
            .init(text: "Udemy Kursu",messageIsMine: false),
            .init(text: "Udemy Kursu",messageIsMine: true),
            .init(text: "Udemy Kursu",messageIsMine: true),]
        
        view.addSubview(navBar)
        navBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,boyut: .init(width: 0, height: navBarHeight))
        collectionView.contentInset.top = navBarHeight
        
        let statusBar = UIView(arkaPlanRenk: .white)
        view.addSubview(statusBar)
        statusBar.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        
        collectionView.verticalScrollIndicatorInsets.top = navBarHeight
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
