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
    private let titlesStackView     = UIStackView()
    private let hotelTitleLabel     = UILabel()
    private let hotelAddressLabel   = UILabel()
    private let detailsStackView    = UIStackView()
    private let hotelDistannceView  = UIButton()
    private let hotelSuitesView     = UIButton()
    
    // MARK: -
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        configureImageView()
        configureStackView()
        configureHotelTitleLabel()
        configureHotelAddressLabel()
        configureDetailsStackView()
        configureHotelDistanceView()
        configureHotelSuitesView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        DispatchQueue.main.async {
            self.hotelImageView.image   = Project.Image.defaultPhotoImage
            self.hotelAddressLabel.text = nil
            self.hotelAddressLabel.text = nil
        }
    }
    
    // MARK: - Handle methods
    private func bindWith(_ hotelViewModel: HotelViewModel) {
        DispatchQueue.main.async {
            self.hotelTitleLabel.text   = hotelViewModel.name
            self.hotelAddressLabel.text = hotelViewModel.address
            self.hotelDistannceView.setTitle(String(hotelViewModel.distance), for: .normal)
            self.hotelSuitesView.setTitle(String(hotelViewModel.availableSuites.count), for: .normal)
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
        self.backgroundColor = Project.Color.cellBackground
        self.layer.configureWith(cornerRadius: 18, addShadow: true)
    }
    
    private func configureImageView() {
        self.addSubview(hotelImageView)
        hotelImageView.translatesAutoresizingMaskIntoConstraints = false
        
        hotelImageView.contentMode   = .scaleAspectFit
        hotelImageView.image         = Project.Image.defaultPhotoImage
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
        stackView.alignment = .top
        stackView.isUserInteractionEnabled = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: hotelImageView.trailingAnchor, constant: 15),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
    }
    
    private func configureHotelTitleLabel() {
        stackView.addArrangedSubview(hotelTitleLabel)
        
        hotelTitleLabel.configureWith(fontSize: 16, fontWeight: .medium, titleColor: .label)
        hotelTitleLabel.configureWith(numberOfLines: 2)
    }
    
    private func configureHotelAddressLabel() {
        stackView.addArrangedSubview(hotelAddressLabel)
        stackView.setCustomSpacing(50, after: hotelAddressLabel)
        
        hotelAddressLabel.configureWith(fontSize: 15, fontWeight: .regular, titleColor: .secondaryLabel)
        hotelAddressLabel.configureWith(textAlignmnet: .left, numberOfLines: 2)
    }
    
    private func configureDetailsStackView() {
        self.addSubview(detailsStackView)
        detailsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        detailsStackView.axis = .horizontal
        detailsStackView.spacing = 15
        detailsStackView.isUserInteractionEnabled = false
        
        NSLayoutConstraint.activate([
            detailsStackView.leadingAnchor.constraint(equalTo: hotelImageView.trailingAnchor, constant: 15),
            detailsStackView.topAnchor.constraint(greaterThanOrEqualTo: stackView.bottomAnchor, constant: 10),
            detailsStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -15),
            detailsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ])
    }
    
    private func configureHotelDistanceView() {
        self.detailsStackView.addArrangedSubview(hotelDistannceView)
        hotelDistannceView.setImage(Project.Image.mappinnImage, for: .normal)
        hotelDistannceView.imageView?.tintColor = .systemOrange
        hotelDistannceView.layer.configureWith(cornerRadius: 15)
        hotelDistannceView.configureWith(fontSize: 15, fontWeight: .regular, color: .systemGray)
        hotelDistannceView.setInsets(forContentPadding: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10), imageTitlePadding: 7)
    }
    
    private func configureHotelSuitesView() {
        self.detailsStackView.addArrangedSubview(hotelSuitesView)
        hotelSuitesView.setImage(Project.Image.bedImage, for: .normal)
        hotelSuitesView.imageView?.tintColor = .systemOrange
        hotelSuitesView.setInsets(forContentPadding: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10), imageTitlePadding: 7)
        hotelSuitesView.configureWith(fontSize: 15, fontWeight: .regular, color: .systemGray2)
        hotelSuitesView.layer.configureWith(cornerRadius: 15)
    }
}
