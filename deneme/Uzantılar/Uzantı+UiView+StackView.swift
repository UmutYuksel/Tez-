//
//  Uzantı+UiView+StackView.swift
//  tez
//
//  Created by Umut Yüksel on 18.12.2022.
//

import UIKit

extension UIView {
    
    fileprivate func _stackViewOlustur(_ axis : NSLayoutConstraint.Axis = .vertical, views : [UIView], spacing : CGFloat = 0, alignment : UIStackView.Alignment = .fill, distribution : UIStackView.Distribution = .fill) -> UIStackView {
        let sv = UIStackView(arrangedSubviews: views)
        sv.axis = axis
        sv.spacing = spacing
        sv.alignment = alignment
        sv.distribution = distribution
        addSubview(sv)
        sv.doldurSuperView()
        return sv
    }
    
    @discardableResult
    public func stackViewOlustur(_ views : UIView..., spacing : CGFloat = 0, alignment : UIStackView.Alignment = .fill, distribution : UIStackView.Distribution = .fill) -> UIStackView {
        return _stackViewOlustur(.vertical, views: views, spacing: spacing, alignment: alignment, distribution: distribution)
    }
    
    @discardableResult
    public func yatayStackViewOlustur(_ views : UIView..., spacing : CGFloat = 0, alignment : UIStackView.Alignment = .fill, distribution : UIStackView.Distribution = .fill) -> UIStackView {
        return _stackViewOlustur(.horizontal, views: views, spacing: spacing, alignment: alignment, distribution: distribution)
    }
    
    @discardableResult
    func boyutlandir<T : UIView>(_ boyut : CGSize) -> T {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: boyut.width).isActive = true
        heightAnchor.constraint(equalToConstant: boyut.height).isActive = true
        return self as! T
    }
    
    
    func yukseklikAyarla(_ yukseklik : CGFloat) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: yukseklik).isActive = true
        return self
    }
    
    func genislikAyarla(_ genislik : CGFloat) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: genislik).isActive = true
        return self
    }
    
    func kenarlikEkle<T : UIView> (genislik : CGFloat, color : UIColor) -> T {
        layer.borderWidth = genislik
        layer.borderColor = color.cgColor
        return self as! T
    }
}

extension UIEdgeInsets {
    static public func tumKenarlar(_ deger : CGFloat) -> UIEdgeInsets {
        return .init(top: deger, left: deger, bottom: deger, right: deger)
    }
}

extension UIImageView {
    
    convenience init(image: UIImage?, contentMode: UIView.ContentMode = .scaleAspectFill) {
        self.init(image: image)
        self.contentMode = contentMode
        self.clipsToBounds = true
    }
}
