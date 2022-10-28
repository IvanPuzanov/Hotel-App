//
//  HEHotelCVCell.swift
//  Hotel App
//
//  Created by Ivan Puzanov on 28.10.2022.
//

import UIKit
import RxSwift

final class HEHotelCVCell: UICollectionViewCell {
    
    // MARK: - Parameters
    private let disposeBag = DisposeBag()
    static let cellID = "HEHotelCVCellID"
    
    public var hotelViewModel: HotelViewModel! {
        didSet {
            bindWith(hotelViewModel)
        }
    }
    
    // MARK: - Views
    private let imageView           = UIImageView()
    private let stackView           = UIStackView()
    private let hotelTitleLabel     = UILabel()
    private let hotelAddressLabel   = UILabel()
    
    // MARK: -
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        configureImageView()
        configureStackView()
        configureHotelTitleLabel()
        configureHotelAddressLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handle methods
    private func bindWith(_ hotelViewModel: HotelViewModel) {
        DispatchQueue.main.async {
            self.hotelTitleLabel.text   = hotelViewModel.name
            self.hotelAddressLabel.text = hotelViewModel.address
        }
        
        self.hotelViewModel.image.subscribe { hotelImage in
            DispatchQueue.main.async {
                self.imageView.image = hotelImage
            }
        } onError: { _ in }.disposed(by: disposeBag)
    }
    
    // MARK: -
    private func configure() {
        self.backgroundColor = .systemBackground
    }
    
    private func configureImageView() {
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode   = .scaleAspectFit
        imageView.image         = UIImage(systemName: "photo.fill")
        imageView.tintColor     = .quaternarySystemFill
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func configureStackView() {
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.isUserInteractionEnabled = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15),
            stackView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
    }
    
    private func configureHotelTitleLabel() {
        self.stackView.addArrangedSubview(hotelTitleLabel)
        hotelTitleLabel.configureWith(fontSize: 16, fontWeight: .regular, titleColor: .label)
        hotelTitleLabel.configureWith(numberOfLines: 2)
    }
    
    private func configureHotelAddressLabel() {
        self.stackView.addArrangedSubview(hotelAddressLabel)
        hotelAddressLabel.configureWith(fontSize: 15, fontWeight: .regular, titleColor: .secondaryLabel)
        hotelAddressLabel.configureWith(textAlignmnet: .left, numberOfLines: 2)
    }
}
