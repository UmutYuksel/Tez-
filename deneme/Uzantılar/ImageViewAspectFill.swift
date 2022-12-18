//
//  ImageViewAspectFill.swift
//  tez
//
//  Created by Umut Yüksel on 14.12.2022.
//

import UIKit

class ImageViewAspectFill : UIImageView {

    convenience init() {
        self.init(image: nil)
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
}
