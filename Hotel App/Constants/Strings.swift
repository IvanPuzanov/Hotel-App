//
//  Strings.swift
//  Hotel App
//
//  Created by Ivan Puzanov on 28.10.2022.
//

import Foundation

enum Strings {
    static let hotelListControllerTitle = "Hotel"
    static func sortTitle(by sortType: SortType) -> String {
        switch sortType {
        case .byDistance:
            return "По дистанции"
        case .bySuites:
            return "По номерам"
        }
    }
    
    static let networkErrorTitle = "Что-то пошло не так"
    static let networkErrorMesssage = "Ошибка при получении данных"
}
