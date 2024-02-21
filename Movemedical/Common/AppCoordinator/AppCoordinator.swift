//
//  AppCoordinator.swift
//  Movemedical
//
//  Created by Jurica Bozikovic on 18.02.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import UIKit

//  MARK: - Coordinator protocol
protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var presenter: UINavigationController { get set }
    func start()
}

extension Coordinator {
    func addChildCoordinator(coordinator: Coordinator) {
        self.childCoordinators.append(coordinator)
    }

    func removeChildCoordinator(coordinator: Coordinator) {
        guard !self.childCoordinators.isEmpty else { return }
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
    }
    
    func removeAllChildCoordinators() {
        self.childCoordinators.removeAll()
    }
}


//  MARK: - AppCoordinator
class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator]
    var presenter: UINavigationController
    let window: UIWindow?
    
    // MARK: - Initializer
    init(window: UIWindow?) {
        self.window = window
        presenter = UINavigationController()
        childCoordinators = []
    }
    
    func start() {
        guard let window = self.window else { return }
        window.rootViewController = presenter
        window.makeKeyAndVisible()        
        startAppointmentsCoordinator()
    }
}


//  MARK: - RepositoriesCoordinator
private extension AppCoordinator {
    func startAppointmentsCoordinator() {
        let coordinator = AppointmentsCoordinator(presenter: presenter)
        self.addChildCoordinator(coordinator: coordinator)
        coordinator.start()
    }
}
