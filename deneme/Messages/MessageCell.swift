//
//  MessageCell.swift
//  tez
//
//  Created by Umut Yüksel on 20.12.2022.
//

import UIKit

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
            txtMessage.text = veri.message
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
