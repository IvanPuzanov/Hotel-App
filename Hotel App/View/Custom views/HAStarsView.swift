//
//  HotelStarsView.swift
//  Hotel App
//
//  Created by Ivan Puzanov on 28.10.2022.
//

import UIKit

final class HAStarsView: UIView {
    
    private let stackView = UIStackView()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(alignment: UIStackView.Alignment = .center) {
        self.init(frame: .zero)
        
        self.stackView.alignment = alignment
    }
    
    // MARK: -
    public func setStars(of count: Float) {
        guard !count.isZero else { return }
        (1...Int(count)).forEach { _ in
            let imageView           = UIImageView(frame: .init(origin: .zero, size: CGSize(width: 40, height: 40)))
            imageView.image         = Image.starImage
            imageView.tintColor     = .secondaryLabel
            imageView.contentMode   = .scaleAspectFit
            
            self.stackView.addArrangedSubview(imageView)
        }
    }
    
    // MARK: -
    private func configureStackView() {
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.spacing = 5
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
}
