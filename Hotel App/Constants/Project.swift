//
//  Project.swift
//  Hotel App
//
//  Created by Ivan Puzanov on 28.10.2022.
//

import UIKit

enum Project {
    enum Color {
        static let cellBackground = UIColor(named: "cellBackground")
    }
    
    enum Image {
        static let defaultPhotoImage    = UIImage(systemName: "photo.fill")
        static let starImage            = UIImage(systemName: "star.fill")
        static let mappinnImage         = UIImage(systemName: "mappin.and.ellipse")
        static let mapFillImage         = UIImage(systemName: "map.fill")
        static let bedImage             = UIImage(systemName: "bed.double.fill")
    }
    
    enum Strings {
        static let hotelListControllerTitle = "Hotel"
        static let networkErrorTitle        = "Что-то пошло не так"
        static let networkErrorMesssage     = "Ошибка при получении данных"
        static let extraInfoTitle           = "Дополнительная информация"
        static let sortTitle                = "Сортировать"
        
        static func sortTitle(by sortType: SortType) -> String {
            switch sortType {
            case .byDistance:
                return "По дистанции"
            case .bySuites:
                return "По номерам"
            }
        }
    }
}
