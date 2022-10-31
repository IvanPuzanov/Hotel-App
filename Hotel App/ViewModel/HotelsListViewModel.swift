//
//  HotelsResultViewModel.swift
//  Hotel App
//
//  Created by Ivan Puzanov on 28.10.2022.
//

import RxSwift

final class HotelsListViewModel: ViewModel {
    
    struct Input {
        var loadHotels: Observable<Void>
    }
    
    struct Output {
        var hotels: Observable<[HotelViewModel]>
    }
    
    func transform(_ input: Input) -> Output {
        let networkManager  = NetworkManager()
        let hotels          = networkManager
            .fetchData(ofType: [Hotel].self, from: NetworkLink.hotelsList)
            .map { hotelsList in
            hotelsList.map { hotel in
                HotelViewModel(hotel: hotel)
            }
        }
        
        let output = Output(hotels: hotels)
        
        return output
    }
    
}
