//
//  FotografSeciciController.swift
//  deneme
//
//  Created by Umut Yüksel on 24.10.2022.
//

import Foundation
import UIKit

class FotografSeciciController : UICollectionViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .yellow
        buttonAdd()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "hucreID")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hucre = collectionView.dequeueReusableCell(withReuseIdentifier:"hucreID", for: indexPath)
        hucre.backgroundColor = .black
        return hucre
    }
    fileprivate func buttonAdd() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "İptal Et",style: .plain, target: self, action: #selector(btnIptalPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sonraki", style: .plain, target: self, action: #selector(btnSonrakiPressed))
    }
    @objc func btnSonrakiPressed() {
        
    }
    @objc func btnIptalPressed() {
        dismiss(animated: true,completion: nil)
    }
}

extension FotografSeciciController : UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let genislik = (view.frame.width - 3) / 4
        return CGSize(width: genislik, height: genislik)
    }
}
