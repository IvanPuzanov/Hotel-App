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
    public var image: BehaviorRelay<UIImage?> = .init(value: UIImage(systemName: "photo.fill"))
    
    // MARK: - Initialization
    init(hotel: Hotel) {
        let netwotkManager = NetworkManager()
        
        self.name = hotel.name
        self.address = hotel.address
        
        let detailedHotel = netwotkManager.fetchData(ofType: Hotel.self, from: NetworkLink.hotelLink(for: hotel.id))
    }
    
}

extension HotelViewModel: Hashable {
    static func == (lhs: HotelViewModel, rhs: HotelViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {}
}
