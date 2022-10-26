//
//  FotografPaylasController.swift
//  deneme
//
//  Created by Umut Yüksel on 26.10.2022.
//

import UIKit

class FotografPaylasController : UIViewController {
    var secilenFotograf : UIImage? {
        didSet {
            self.imgPaylasim.image = secilenFotograf
        }
    }
    let txtMesaj : UITextView = {
        let txt = UITextView()
        txt.font = UIFont.systemFont(ofSize: 15)
        return txt
    }()
    let imgPaylasim : UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgbDonustur(red: 240, green: 240, blue: 240)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Paylaş", style: .plain, target: self, action: #selector(btnPaylasPressed))
        fotografMesajAlanlariniOlustur()
    }
    
    fileprivate func fotografMesajAlanlariniOlustur() {
        
        let paylasimView = UIView()
        paylasimView.backgroundColor = .white
        
        view.addSubview(paylasimView)
        paylasimView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 120)
        
        view.addSubview(imgPaylasim)
        imgPaylasim.anchor(top: paylasimView.topAnchor, bottom: paylasimView.bottomAnchor, leading: paylasimView.leadingAnchor, trailing: nil, paddingTop: 8, paddingBottom: -8, paddingLeft: 8, paddingRight: 0, width: 85, height: 0)
        view.addSubview(txtMesaj)
        
        txtMesaj.anchor(top: paylasimView.topAnchor, bottom: paylasimView.bottomAnchor, leading: imgPaylasim.trailingAnchor, trailing: paylasimView.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 5, paddingRight: 0, width: 0, height: 0)
    }
    
    @objc fileprivate func btnPaylasPressed() {
        
    }
}
