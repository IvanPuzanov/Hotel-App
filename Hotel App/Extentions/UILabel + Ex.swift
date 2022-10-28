//
//  UILabel + Ex.swift
//  Hotel App
//
//  Created by Ivan Puzanov on 28.10.2022.
//

import UIKit

extension UILabel {
    
    func setTitle(_ title: String) {
        self.text = title
    }
    
    func configureWith(fontSize: CGFloat = 16, fontWeight: UIFont.Weight = .regular, titleColor: UIColor = .label) {
        self.font       = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        self.textColor  = titleColor
    }
    
    func configureWith(textAlignmnet: NSTextAlignment = .left, numberOfLines: Int = 1) {
        self.textAlignment = textAlignmnet
        self.numberOfLines = numberOfLines
    }
    
}
