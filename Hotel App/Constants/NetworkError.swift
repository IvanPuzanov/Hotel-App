//
//  NetworkError.swift
//  Hotel App
//
//  Created by Ivan Puzanov on 28.10.2022.
//

import Foundation

enum NetworkError: String, Error {
    case failURL        = "Fail URL"
    case failedDecode   = "Fail to decode"
}
