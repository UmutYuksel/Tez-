//
//  CameraController.swift
//  deneme
//
//  Created by Umut Yüksel on 24.11.2022.
//

import UIKit
import AVFoundation
import JGProgressHUD

class CameraController : UIViewController , UIViewControllerTransitioningDelegate {
    
    let btnBack : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "right arrow.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(btnBackPressed), for: .touchUpInside)
        return btn
    }()
    
    @objc fileprivate func btnBackPressed() {
        dismiss(animated: true,completion: nil)
    }
    
    let btnTakePicture : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "photo.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(btnTakePicturePressed), for: .touchUpInside)
        return btn
    }()
    
    @objc fileprivate func btnTakePicturePressed() {
        print("Fotograf çekti")
        
        let settings = AVCapturePhotoSettings()
        cikti.capturePhoto(with: settings, delegate: self)
    }
    
    fileprivate func gorunumuDuzenle() {
        view.addSubview(btnTakePicture)
        btnTakePicture.anchor(top: nil, bottom: view.bottomAnchor, leading: nil, trailing: nil, paddingTop: 0, paddingBottom: -10, paddingLeft: 0, paddingRight: -15, width: 80, height: 80)
        btnTakePicture.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(btnBack)
        btnBack.anchor(top: view.topAnchor, bottom: nil, leading: nil, trailing: view.trailingAnchor, paddingTop: 30, paddingBottom: 0, paddingLeft: 0, paddingRight: -15, width: 50, height: 50)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        fotografAl()
        
        gorunumuDuzenle()
        
        transitioningDelegate = self
    }
    let cikti = AVCapturePhotoOutput()
    fileprivate func fotografAl() {
        
        let captureSession = AVCaptureSession()
        
        guard let cihaz = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        
        do {
            let giris = try AVCaptureDeviceInput(device: cihaz)
            
            if captureSession.canAddInput(giris) {
                captureSession.addInput(giris)
            }
        } catch let hata {
            print("Kameraya Erişilemiyor :",hata.localizedDescription)
        }
        if captureSession.canAddOutput(cikti) {
            captureSession.addOutput(cikti)
        }
        let onizleme = AVCaptureVideoPreviewLayer(session: captureSession)
        onizleme.frame = view.frame
        view.layer.addSublayer(onizleme)
        captureSession.startRunning()
        
    }
    
    let animasyonSunum = Animation()
    let animationDismiss = AnimationDismiss()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animasyonSunum
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animationDismiss
    }
    
    @objc fileprivate func btnIptalPressed() {
        
    }
    
    @objc fileprivate func btnSonrakiPressed() {
        
        let fotoPaylasController = FotografPaylasController()
        navigationController?.pushViewController(fotoPaylasController, animated: true)
    }
    
}

extension CameraController :AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("Çekilen Fotoğraf hafızayan alındı")
        
        guard let goruntuVerisi = photo.fileDataRepresentation() else { return }
        
        let goruntuOnizleme = UIImage(data: goruntuVerisi)
        let imgGoruntuOnizleme = UIImageView(image: goruntuOnizleme)
        
        view.addSubview(imgGoruntuOnizleme)
        
        imgGoruntuOnizleme.anchor(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Fotoğraf Çekiliyor"
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 1)
        
        
    }
}
