//
//  NetworkLink.swift
//  Hotel App
//
//  Created by Ivan Puzanov on 28.10.2022.
//

import Foundation

enum NetworkLink {
    static let hotelsList = "https://raw.githubusercontent.com/iMofas/ios-android-test/master/0777.json"
    
    static func hotelLink(for id: Int) -> String {
        return "https://raw.githubusercontent.com/iMofas/ios-android-test/master/\(id).json"
    }
    
    static func imageLink(for id: String?) -> String {
        guard let id = id else { return "" }
        return "https://github.com/iMofas/ios-android-test/raw/master/\(id)"
    }
}
