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
    
    func start() {
        let viewController = HotelsListVC(collectionViewLayout: UICollectionViewLayout())
        navigationController.pushViewController(viewController, animated: true)
    }
}
