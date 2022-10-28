//
//  Hotel.swift
//  Hotel App
//
//  Created by Ivan Puzanov on 28.10.2022.
//

import Foundation

struct Hotel: Codable {
    var id: Int
    var name: String
    var address: String
    var stars: Float
    var distance: Float
    var suitesAvailability: String
    var image: String?
    var lat: Double?
    var lon: Double?
}
