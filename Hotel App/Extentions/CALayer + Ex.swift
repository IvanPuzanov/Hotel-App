//
//  CALayer + Ex.swift
//  Hotel App
//
//  Created by Ivan Puzanov on 28.10.2022.
//

import UIKit

extension CALayer {
    func configureWith(cornerRadius: CGFloat, addShadow: Bool = false) {
        self.cornerRadius   = cornerRadius
        self.cornerCurve    = .continuous
        
        guard addShadow else { return }
        self.shadowColor    = UIColor.black.cgColor
        self.shadowOpacity  = 0.08
        self.shadowRadius   = 5
        self.shadowOffset   = CGSize(width: 0, height: 0)
    }
}
