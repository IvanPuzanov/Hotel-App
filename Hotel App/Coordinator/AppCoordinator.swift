//
//  AppCoordinator.swift
//  Hotel App
//
//  Created by Ivan Puzanov on 28.10.2022.
//

import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let viewController = HotelsListVC(collectionViewLayout: UICollectionViewLayout())
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    public func showDetailedHotelVC(for hotelViewModel: HotelViewModel?) {
        let viewController = HotelVC()
        viewController.hotelViewModel = hotelViewModel
        navigationController.present(viewController, animated: true)
    }
}
