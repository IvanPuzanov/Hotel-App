//
//  HotelViewModel.swift
//  Hotel App
//
//  Created by Ivan Puzanov on 28.10.2022.
//

import RxSwift
import RxRelay

final class HotelViewModel {
    
    private let disposeBag = DisposeBag()
    private let id = UUID().uuidString
    
    public var name: String
    public var address: String
    public var stars: Float
    public var distance: Float
    public var image: BehaviorRelay<UIImage?> = .init(value: nil)
    public var availableSuites: [Int]
    public var longitude: Double?
    public var latitude: Double?
    
    // MARK: - Initialization
    init(hotel: Hotel) {
        self.name               = hotel.name
        self.address            = hotel.address
        self.stars              = hotel.stars
        self.distance           = hotel.distance
        self.availableSuites    = hotel.suitesAvailability.components(separatedBy: ":").map { Int($0) ?? 0 }
        self.longitude          = hotel.lon
        self.latitude           = hotel.lat
        
        fetchImage(for: hotel)
    }
    
    // MARK: - Handle methods
    /// Fetching image for viewModel
    /// - Parameter hotel: Hotel object
    private func fetchImage(for hotel: Hotel) {
        let networkManager  = NetworkManager()
        let detailedHotel   = networkManager.fetchData(ofType: Hotel.self, from: NetworkLink.hotelLink(for: hotel.id))
        
        detailedHotel.subscribe { hotelValue in
            self.longitude = hotelValue.lon
            self.latitude  = hotelValue.lat
            
            networkManager.fetchImage(from: hotelValue.image) { result in
                switch result {
                case .success(let hotelImage):
                    DispatchQueue.main.async {
                        self.image.accept(hotelImage?.imageWithInsets(insetDimen: -1))
                    }
                default:
                    DispatchQueue.main.async {
                        self.image.accept(nil)
                    }
                }
            }
        } onError: { _ in }.disposed(by: self.disposeBag)
    }
    
    /// Preparing suites data
    /// - Parameter suites: Suites string
    /// - Returns: Arrays of suites
    private func transformSuites(_ suites: String) -> [Int] {
        var result = [Int]()
        suites.components(separatedBy: ":").forEach {
            if let number = Int($0) {
                result.append(number)
            }
        }
        return result
    }
    
}

extension HotelViewModel: Hashable {
    static func == (lhs: HotelViewModel, rhs: HotelViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {}
}
