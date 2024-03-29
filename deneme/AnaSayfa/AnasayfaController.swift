//
//  AnasayfaController.swift
//  deneme
//
//  Created by Umut Yüksel on 28.10.2022.
//

import UIKit
import Firebase

class AnasayfaController : UICollectionViewController {
    
    let hucreID = "hucreID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(paylasimlariYenile), name: FotografPaylasController.guncelleNotification, object: nil)
        
        collectionView.backgroundColor = .white
        collectionView.register(AnaPaylasimCell.self, forCellWithReuseIdentifier: hucreID)

        kullaniciyiGetir() // Oturumu açan Kullanıcının Paylaşımları Getirilir
        takipEdilenKIDDegerleriGetir()
        editNavBar()
        
        navBar.btnMessages.addTarget(self, action: #selector(btnMessagePressed), for: .touchUpInside)
        navBar.btnSharePhoto.addTarget(self, action: #selector(btnSharePhotoPressed), for: .touchUpInside)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(paylasimlariYenile), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc fileprivate func btnMessagePressed() {
        let messageController = LastMessagesController()
        view.backgroundColor = .white
        navigationController?.pushViewController(messageController, animated: true)
    }
    
    @objc fileprivate func btnSharePhotoPressed() {
        let layout = UICollectionViewFlowLayout()
        let newShareController = FotografSeciciController(collectionViewLayout: layout)
        let navController = UINavigationController(rootViewController: newShareController)
        navController.modalPresentationStyle = .fullScreen
        view.backgroundColor = .white
        navigationController?.pushViewController(newShareController, animated: true)
    }
    fileprivate func ekleControllerOlustur()-> UINavigationController {
            let rootController = UIViewController()
            let navController = UINavigationController(rootViewController: rootController)
            navController.tabBarItem.image = UIImage(named: "add.png")
            return navController
        }
    
    @objc fileprivate func paylasimlariYenile() {
        print("Paylaşımlar Yenileniyor")
        paylasimlar.removeAll()
        collectionView.reloadData()
        takipEdilenKIDDegerleriGetir()
        kullaniciyiGetir()
    }
    
    let navBar = HomeScreenNavBar()
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    fileprivate func takipEdilenKIDDegerleriGetir() {
        guard let kID = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("TakipEdiyor").document(kID).addSnapshotListener { (documentsnapshot, hata) in
            if let hata = hata {
                print("Paylaşımlar Getirilirken Hata Meydana Geldi : ",hata.localizedDescription)
                return
            }
            guard let paylasimSozlukVerisi = documentsnapshot?.data() else { return }
            
            paylasimSozlukVerisi.forEach { (key,value) in
                
                Firestore.kullaniciyiOlustur(kullaniciID: key) { (kullanici) in
                    self.paylasimlariGetir(kullanici: kullanici)
                }
            }
        }
    }
    
    var paylasimlar = [Paylasim]()
    fileprivate func paylasimlariGetir(kullanici : Kullanici) {
       
       
        Firestore.firestore().collection("Paylasimlar").document(kullanici.kullaniciID)
            .collection("Fotograf_Paylasimlari").order(by: "PaylasimTarihi", descending: false)
            .addSnapshotListener { querySnapshot, hata in
                
                self.collectionView.refreshControl?.endRefreshing()
                
                if let hata = hata {
                    print("Paylaşımlar Getirilirken Hata Oluştu",hata.localizedDescription)
                    return
                }
                querySnapshot?.documentChanges.forEach({ (degisiklik) in
                    if degisiklik.type == .added {
                        let paylasimVerisi = degisiklik.document.data()
                        var paylasim = Paylasim(kullanici : kullanici ,sozlukVerisi: paylasimVerisi)
                        paylasim.id = degisiklik.document.documentID
                        
                        guard let gecerliKullaniciID = Auth.auth().currentUser?.uid else { return }
                        
                        guard let paylasimID = paylasim.id else { return}
                        
                        Firestore.firestore().collection("Begeniler").document(paylasimID).getDocument { (snapshot, hata) in
                            if let hata = hata {
                                print("Beğeni Verileri Alınırken Hata Meydana Geldi",hata.localizedDescription)
                                return
                            }
                            let begeniVerisi = snapshot?.data()
                            
                            if let begeniDegeri = begeniVerisi?[gecerliKullaniciID] as? Int, begeniDegeri == 1 {
                                paylasim.begenildi = true
                            } else {
                                paylasim.begenildi = false
                            }
                            self.paylasimlar.append(paylasim)
                            self.paylasimlar.reverse()
                            self.paylasimlar.sort { (p1 , p2) -> Bool in
                                return p1.paylasimTarihi.dateValue().compare(p2.paylasimTarihi.dateValue()) == .orderedDescending
                            }
                            self.collectionView.reloadData()
                        }
                    }
                })
            }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paylasimlar.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let hucre = collectionView.dequeueReusableCell(withReuseIdentifier: hucreID, for: indexPath) as! AnaPaylasimCell
        hucre.paylasim = paylasimlar[indexPath.row]
        hucre.delegate = self
        return hucre
    }
    var gecerliKullanici : Kullanici?
    
    fileprivate func kullaniciyiGetir(kullaniciID : String = "") {
        guard let gecerliKullaniciID = Auth.auth().currentUser?.uid else { return }
        let kID = kullaniciID == "" ? gecerliKullaniciID : kullaniciID
        
        Firestore.firestore().collection("Kullanicilar").document(kID).getDocument { snapshot, hata in
            
            if let hata = hata {
                print("Kullanıcı Bilgisi Getirilemedi",hata)
                return
            }
            guard let kullaniciVerisi = snapshot?.data() else { return }
            self.gecerliKullanici = Kullanici(kullaniciVerisi: kullaniciVerisi)
            
            guard let kullanici = self.gecerliKullanici else { return }
            self.paylasimlariGetir(kullanici: kullanici)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension AnasayfaController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var yukseklik : CGFloat = 55
        yukseklik += view.frame.width
        yukseklik += 50
        yukseklik += 35
        return CGSize(width: view.frame.width, height: yukseklik)
    }
}

extension AnasayfaController : AnaPaylasimCellDelegate {
    
    func LikePressed(cell: AnaPaylasimCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        var paylasim = self.paylasimlar[indexPath.row]
        
        guard let paylasimID = paylasim.id else { return }
        guard let gecerliKullaniciID = Auth.auth().currentUser?.uid else { return }
        
        let eklenecekDeger = [gecerliKullaniciID : paylasim.begenildi == true ? 0 : 1]
        
        Firestore.firestore().collection("Begeniler").document(paylasimID).getDocument { (snapshot, hata) in
            
            if let hata = hata {
                print("Beğeni Verisi Alınamadı",hata.localizedDescription)
                return
            }
            
            if snapshot?.exists == true {
                Firestore.firestore().collection("Begeniler").document(paylasimID).updateData(eklenecekDeger) { (hata) in
                    if let hata = hata {
                        print("Beğeni Güncellemesi Başarısız",hata.localizedDescription)
                        return
                    }
                    print("Paylaşım Beğenildi")
                    paylasim.begenildi = !paylasim.begenildi
                    self.paylasimlar[indexPath.row] = paylasim
                    self.collectionView.reloadItems(at: [indexPath])
                }
            } else {
                Firestore.firestore().collection("Begeniler").document(paylasimID).setData(eklenecekDeger) { (hata) in
                    if let hata = hata {
                        print("Beğeni Verisi Kaydı Başarısız",hata.localizedDescription)
                        return
                    }
                    print("Beğeni Verisi Başarılı")
                    paylasim.begenildi = !paylasim.begenildi
                    self.paylasimlar[indexPath.row] = paylasim
                    self.collectionView.reloadItems(at: [indexPath])
                }
            }
        }
    }
    
    func CommentPressed(paylasim : Paylasim) {
        let commentsController = YorumlarController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.secilenPaylasim = paylasim
        navigationController?.pushViewController(commentsController, animated: true)
    }
}
