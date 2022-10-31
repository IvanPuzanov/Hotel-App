//
//  HEHotelCVCell.swift
//  Hotel App
//
//  Created by Ivan Puzanov on 28.10.2022.
//

import UIKit
import RxSwift

final class HAHotelCVCell: UICollectionViewCell {
    
    // MARK: - Parameters
    private let disposeBag = DisposeBag()
    static let cellID = "HEHotelCVCellID"
    
    public var hotelViewModel: HotelViewModel! {
        didSet {
            bindWith(hotelViewModel)
        }
    }
    
    // MARK: - Views
    private let hotelImageView      = UIImageView()
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
    
    override func prepareForReuse() {
        DispatchQueue.main.async {
            self.hotelImageView.image   = Image.defaultPhotoImage
            self.hotelAddressLabel.text = nil
            self.hotelAddressLabel.text = nil
        }
    }
    
    // MARK: - Handle methods
    private func bindWith(_ hotelViewModel: HotelViewModel) {
        DispatchQueue.main.async {
            self.hotelTitleLabel.text   = hotelViewModel.name
            self.hotelAddressLabel.text = hotelViewModel.address
        }
        
        self.hotelViewModel.image.subscribe { hotelImage in
            DispatchQueue.main.async {
                guard let hotelImage = hotelImage else { return }
                self.hotelImageView.image = hotelImage
            }
        } onError: { _ in }.disposed(by: disposeBag)
    }
    
    // MARK: -
    private func configure() {
        self.backgroundColor = .systemBackground
        self.layer.configureWith(cornerRadius: 18, addShadow: true)
    }
    
    private func configureImageView() {
        self.addSubview(hotelImageView)
        hotelImageView.translatesAutoresizingMaskIntoConstraints = false
        
        hotelImageView.contentMode   = .scaleAspectFit
        hotelImageView.image         = Image.defaultPhotoImage
        hotelImageView.tintColor     = .quaternarySystemFill
        
        NSLayoutConstraint.activate([
            hotelImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            hotelImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            hotelImageView.heightAnchor.constraint(equalToConstant: 100),
            hotelImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func configureStackView() {
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.isUserInteractionEnabled = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: hotelImageView.trailingAnchor, constant: 15),
            stackView.centerYAnchor.constraint(equalTo: hotelImageView.centerYAnchor),
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
