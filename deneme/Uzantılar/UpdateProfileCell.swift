//
//  UpdateProfieCell.swift
//  tez
//
//  Created by Umut Yüksel on 28.12.2022.
//

import UIKit

class UpdateProfileCell: UITableViewCell, UITextFieldDelegate {

    class ProfileTextField : UITextField {
        
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 25, dy: 0)
        }
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 25, dy: 0 )
        }
        
        override var intrinsicContentSize: CGSize {
            return .init(width: 0, height: 45)
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }
    
    let textField : UITextField = {
        let txt = ProfileTextField()
        txt.placeholder = "Kullanıcı Adı"
        txt.keyboardType = .emailAddress
        return txt
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(textField)
        textField.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        textField.doldurSuperView()
        textField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
