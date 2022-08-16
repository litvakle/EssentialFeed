//
//  UIImageView+Animations.swift
//  EssentialFeediOS
//
//  Created by Lev Litvak on 16.08.2022.
//

import UIKit

extension UIImageView {
    func setImageAnimated(_ newImage: UIImage) {
        image = newImage
        
        alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
}
