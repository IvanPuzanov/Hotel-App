//
//  HotelVC.swift
//  Hotel App
//
//  Created by Ivan Puzanov on 28.10.2022.
//

import UIKit
import RxSwift
import MapKit

final class HotelVC: UIViewController {

    // MARK: - Parameters
    private let disposeBag      = DisposeBag()
    public var hotelViewModel: HotelViewModel?
    
    // MARK: - Views
    private let scrollView          = UIScrollView()
    private let contentView         = UIView()
    private let stackView           = UIStackView()
    private let hotelImageView      = UIImageView()
    private let hotelTitleLabel     = UILabel()
    private let hotelAddressLabel   = UILabel()
    private let hotelStarsView      = HAStarsView(alignment: .leading)
    private let detailsLabel        = UILabel()
    private let detailsStackView    = UIStackView()
    private let hotelDistannceView  = UIButton()
    private let hotelSuitesView     = UIButton()
    private let mapView             = MKMapView()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureRootView()
        configureSrollView()
        configureContentView()
        configureStackView()
        configureHotelTitleLabel()
        configureHotelAddressLabel()
        configureHotelStarsView()
        configureImageView()
        configureDetailsLabel()
        configureDetailsStackView()
        configureHotelDistanceView()
        configureHotelSuitesView()
        configureMapView()
        
        bind()
    }
    
    // MARK: - Binding
    private func bind() {
        guard let hotelViewModel = hotelViewModel else { return }
        
        DispatchQueue.main.async {
            self.hotelTitleLabel.setTitle(hotelViewModel.name)
            self.hotelAddressLabel.setTitle(hotelViewModel.address)
            self.hotelDistannceView.setTitle(String(hotelViewModel.distance), for: .normal)
            self.hotelSuitesView.setTitle(String(hotelViewModel.availableSuites.count), for: .normal)
            
            if let longitude = hotelViewModel.longitude, let latitude = hotelViewModel.latitude {
                self.mapView.setPinUsingMKAnnotation(title: hotelViewModel.name,
                                                     location: .init(latitude: latitude,
                                                                     longitude: longitude))
            }
            
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
                self.hotelImageView.contentMode = .scaleAspectFill
            }
        } onError: { _ in }.disposed(by: self.disposeBag)
    }

    // MARK: -
    private func configureRootView() {
        self.view.backgroundColor = .systemBackground
    }
    
    private func configureSrollView() {
        self.view.addSubview(scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureContentView() {
        self.scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    private func configureStackView() {
        self.contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
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
        hotelImageView.image            = Project.Image.defaultPhotoImage
        hotelImageView.layer.configureWith(cornerRadius: 18)
        hotelImageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            hotelImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            hotelImageView.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 9/16)
        ])
    }
    
    private func configureDetailsLabel() {
        self.stackView.setCustomSpacing(40, after: hotelImageView)
        self.stackView.addArrangedSubview(detailsLabel)
        
        self.detailsLabel.configureWith(fontSize: 18, fontWeight: .semibold, titleColor: .label)
        self.detailsLabel.configureWith(textAlignmnet: .left, numberOfLines: 1)
        self.detailsLabel.text = Project.Strings.extraInfoTitle
    }
    
    private func configureDetailsStackView() {
        self.contentView.addSubview(detailsStackView)
        detailsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        detailsStackView.spacing = 15
        
        NSLayoutConstraint.activate([
            detailsStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            detailsStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 15),
            detailsStackView.trailingAnchor.constraint(lessThanOrEqualTo: stackView.trailingAnchor)
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
    
    private func configureMapView() {
        self.contentView.addSubview(mapView)
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.layer.configureWith(cornerRadius: 18)
        mapView.mapType = .standard
        
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mapView.topAnchor.constraint(equalTo: detailsStackView.bottomAnchor, constant: 16),
            mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mapView.heightAnchor.constraint(equalToConstant: 220),
            mapView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
