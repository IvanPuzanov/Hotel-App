//
//  ViewModel.swift
//  Hotel App
//
//  Created by Ivan Puzanov on 28.10.2022.
//

import Foundation

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
