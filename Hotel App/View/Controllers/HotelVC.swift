//
//  HotelVC.swift
//  Hotel App
//
//  Created by Ivan Puzanov on 28.10.2022.
//

import UIKit
import RxSwift

final class HotelVC: UIViewController {

    // MARK: - Parameters
    private let disposeBag      = DisposeBag()
    public var hotelViewModel: HotelViewModel?
    
    // MARK: - Views
    private let stackView           = UIStackView()
    private let hotelImageView      = UIImageView()
    private let hotelTitleLabel     = UILabel()
    private let hotelAddressLabel   = UILabel()
    private let hotelStarsView      = HAStarsView(alignment: .leading)
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureRootView()
        configureStackView()
        configureHotelTitleLabel()
        configureHotelAddressLabel()
        configureHotelStarsView()
        configureImageView()
        
        bind()
    }
    
    // MARK: - Binding
    private func bind() {
        guard let hotelViewModel = hotelViewModel else { return }
        
        DispatchQueue.main.async {
            self.hotelTitleLabel.setTitle(hotelViewModel.name)
            self.hotelAddressLabel.setTitle(hotelViewModel.address)
            
            guard !hotelViewModel.stars.isZero else {
                self.hotelStarsView.isHidden = true
                return
            }
            self.hotelStarsView.isHidden = false
            self.hotelStarsView.setStars(of: hotelViewModel.stars)
        }
        
        hotelViewModel.image.subscribe { hotelImage in
            DispatchQueue.main.async {
                guard let hotelImage = hotelImage else { return }
                self.hotelImageView.image = hotelImage.imageWithInsets(insetDimen: -1)
            }
        } onError: { _ in }.disposed(by: self.disposeBag)
    }

    // MARK: -
    private func configureRootView() {
        self.view.backgroundColor = .systemBackground
    }
    
    private func configureStackView() {
        self.view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureHotelTitleLabel() {
        self.stackView.addArrangedSubview(hotelTitleLabel)
        
        self.hotelTitleLabel.configureWith(fontSize: 30, fontWeight: .bold, titleColor: .label)
        self.hotelTitleLabel.configureWith(textAlignmnet: .left, numberOfLines: 0)
    }
    
    private func configureHotelAddressLabel() {
        self.stackView.addArrangedSubview(hotelAddressLabel)
        self.stackView.setCustomSpacing(5, after: hotelTitleLabel)
        
        self.hotelAddressLabel.configureWith(fontSize: 19, fontWeight: .regular, titleColor: .secondaryLabel)
        self.hotelAddressLabel.configureWith(textAlignmnet: .left, numberOfLines: 0)
    }
    
    private func configureHotelStarsView() {
        self.stackView.addArrangedSubview(hotelStarsView)
        self.stackView.setCustomSpacing(10, after: hotelAddressLabel)
        self.hotelStarsView.sizeToFit()
    }
    
    private func configureImageView() {
        self.stackView.addArrangedSubview(hotelImageView)
        self.stackView.setCustomSpacing(20, after: hotelStarsView)
        self.hotelImageView.translatesAutoresizingMaskIntoConstraints = false
        
        hotelImageView.contentMode      = .scaleAspectFit
        hotelImageView.tintColor        = .quaternarySystemFill
        hotelImageView.image            = UIImage(systemName: "photo.fill")
        
        NSLayoutConstraint.activate([
            hotelImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            hotelImageView.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 9/16)
        ])
    }
}
