//
//  LastMessagesController.swift
//  tez
//
//  Created by Umut Yüksel on 18.12.2022.
//

import UIKit

class LastMessagesController : ListeController<MessageCell,Message> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "new-message.png"), style: .plain, target: self, action: #selector(btnNewMessagePressed))
    }
    
    @objc fileprivate func btnNewMessagePressed() {
        let messageController = NewMessage()
        view.backgroundColor = .white
        navigationController?.pushViewController(messageController, animated: true)
    }
    
}
