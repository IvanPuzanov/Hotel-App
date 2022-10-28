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
    public var image: BehaviorRelay<UIImage?> = .init(value: nil)
    
    // MARK: - Initialization
    init(hotel: Hotel) {
        self.name       = hotel.name
        self.address    = hotel.address
        self.stars      = hotel.stars
        
        fetchImage(for: hotel)
    }
    
    private func fetchImage(for hotel: Hotel) {
        let networkManager  = NetworkManager()
        let detailedHotel   = networkManager.fetchData(ofType: Hotel.self, from: NetworkLink.hotelLink(for: hotel.id))
        
        detailedHotel.subscribe { event in
            switch event {
            case .next(let hotelValue):
                networkManager.fetchImage(from: hotelValue.image) { result in
                    switch result {
                    case .success(let hotelImage):
                        self.image.accept(hotelImage)
                    default:
                        self.image.accept(nil)
                    }
                }
            default:
                break
            }
        }.disposed(by: self.disposeBag)
    }
    
}

extension HotelViewModel: Hashable {
    static func == (lhs: HotelViewModel, rhs: HotelViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {}
}
