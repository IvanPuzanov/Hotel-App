//
//  HotelViewModel.swift
//  Hotel App
//
//  Created by Ivan Puzanov on 28.10.2022.
//

import Foundation

final class HotelViewModel {
    
    private let id = UUID().uuidString
    
    init(hotel: Hotel) {
        
    }
    
}

extension HotelViewModel: Hashable {
    static func == (lhs: HotelViewModel, rhs: HotelViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {}
}
