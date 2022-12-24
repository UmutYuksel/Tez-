//
//  ListeCell.swift
//  tez
//
//  Created by Umut Yüksel on 14.12.2022.
//

import UIKit

open class ListeCell<T> : UICollectionViewCell {
    
    var veri : T!
    
    var eklenecekController : UIViewController?
    
    public let ayracView = UIView()
    
    func ayracEkle(solBosluk : CGFloat = 0) {
        addSubview(ayracView)
        ayracView.backgroundColor = .lightGray
        
        ayracView.anchor(top: nil, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: solBosluk, paddingRight: 0, width: 0, height: 0.5)
    }
    
    func ayracEkle(leadingAnchor : NSLayoutXAxisAnchor) {
        addSubview(ayracView)
        
        ayracView.backgroundColor = .lightGray
        ayracView.anchor(top: nil, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        //Liste Controller için oluşturulan her bir ListeCell oluşturulduğunda viewOlustur Çalışacaktır
        viewOlustur()
        
    }
    
    open func viewOlustur() {
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
