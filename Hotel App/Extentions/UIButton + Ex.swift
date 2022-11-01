//
//  UIButton + Ex.swift
//  Hotel App
//
//  Created by Ivan Puzanov on 29.10.2022.
//

import UIKit

extension UIButton {
    func setInsets(forContentPadding contentPadding: UIEdgeInsets, imageTitlePadding: CGFloat) {
        self.contentEdgeInsets = UIEdgeInsets(
            top: contentPadding.top,
            left: contentPadding.left,
            bottom: contentPadding.bottom,
            right: contentPadding.right + imageTitlePadding
        )
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: imageTitlePadding,
            bottom: 0,
            right: -imageTitlePadding
        )
    }
    
    func configureWith(fontSize: CGFloat, fontWeight: UIFont.Weight, color: UIColor) {
        self.titleLabel?.font       = .systemFont(ofSize: fontSize, weight: fontWeight)
        self.backgroundColor        = color.withAlphaComponent(0.07)
        self.imageView?.tintColor   = color
        self.setTitleColor(color, for: .normal)
    }
}
