//
//  FotografSeciciController.swift
//  deneme
//
//  Created by Umut Yüksel on 24.10.2022.
//

import UIKit
import Photos

class FotografSeciciController : UICollectionViewController {

    let hucreID = "hucreID"
    let headerID = "headerID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(FotografSeciciCell.self, forCellWithReuseIdentifier: hucreID)
        collectionView.register(FotografSeciciHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID)
        fotograflariGetir()
        editNavBar()
        
        navBar.btnBack.addTarget(self, action: #selector(btnBackPressed), for: .touchUpInside)
        navBar.btnShare.addTarget(self, action: #selector(btnSharePressed), for: .touchUpInside)
    }
    @objc fileprivate func btnBackPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func btnSharePressed() {
        let fotoPaylasController = FotografPaylasController()
        fotoPaylasController.secilenFotograf = header?.imgHeader.image
        navigationController?.pushViewController(fotoPaylasController, animated: true)
    }
    let navBar = FotografSeciciNavBar()
    fileprivate let navBarHeight : CGFloat = 45
    
    fileprivate func editNavBar() {
        view.addSubview(navBar)
        navBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor,boyut: .init(width: 0, height: navBarHeight))
        collectionView.contentInset.top = navBarHeight
        
        let statusBar = UIView(arkaPlanRenk: .white)
        view.addSubview(statusBar)
        statusBar.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        
        collectionView.verticalScrollIndicatorInsets.top = navBarHeight
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        secilenFotograf = fotograflar[indexPath.row]
        collectionView.reloadData()
        let indexUst = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexUst, at: .bottom, animated: true)
        
    }
    var assetler = [PHAsset]()
    var secilenFotograf : UIImage?
    var fotograflar = [UIImage]()
    
    fileprivate func fotografGetirmeSecenekOlustur() -> PHFetchOptions {
        let getirmeSecenekleri = PHFetchOptions()
        getirmeSecenekleri.fetchLimit = 120
        
        let siralamaAyari = NSSortDescriptor(key: "creationDate", ascending: false)
        getirmeSecenekleri.sortDescriptors = [siralamaAyari]
        return getirmeSecenekleri
    }
    fileprivate func fotograflariGetir() {
        
        let fotograflar = PHAsset.fetchAssets(with: .image, options: fotografGetirmeSecenekOlustur())
        
        DispatchQueue.global(qos: .background).async {
            fotograflar.enumerateObjects { (asset, sayi, durmaNoktasi) in
                
                
             
                // asset içinde fotoğraf bilgileri yer alır
                // sayı kaçıncı fotoğraf getiriliyor 0'dan 9'a kadar
                // durmanoktası fotoğraf getirilirken durulan noktayı tutar
                
                let imageManager = PHImageManager.default()
                let goruntuBoyutu = CGSize(width: 600, height: 600)
                let secenekler = PHImageRequestOptions()
                secenekler.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: goruntuBoyutu, contentMode: .aspectFit, options: secenekler) {
                    (goruntu, goruntuBilgileri) in
                    
                    
                    if let fotograf = goruntu {
                        self.assetler.append(asset)
                        self.fotograflar.append(fotograf)
                        
                        if self.secilenFotograf == nil {
                            self.secilenFotograf = goruntu
                        }
                    }
                    
                    if sayi == fotograflar.count - 1 {
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                }
                
            }
        }
}
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let genislik = view.frame.width
        return CGSize(width: genislik, height: genislik)
    
    }
    var header : FotografSeciciHeader?
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! FotografSeciciHeader
        
        self.header = header
        header.imgHeader.image = secilenFotograf

        
        if let secilenFotograf = secilenFotograf {
            if let index = self.fotograflar.firstIndex(of: secilenFotograf) {
                let secilenAsset = self.assetler[index]
                
                let fotoManager = PHImageManager.default()
                let boyut = CGSize(width: 1200, height: 600)
                fotoManager.requestImage(for: secilenAsset, targetSize: boyut, contentMode: .default, options: nil) {
                    (foto, bilgi) in
                    header.imgHeader.image = foto
                }
            }
        }
        return header
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fotograflar.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hucre = collectionView.dequeueReusableCell(withReuseIdentifier: hucreID , for: indexPath) as! FotografSeciciCell
        hucre.imgFotograf.image = fotograflar[indexPath.row]
        return hucre
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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

extension UINavigationController {
    open override var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }
}
