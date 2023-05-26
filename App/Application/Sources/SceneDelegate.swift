//
//  SceneDelegate.swift
//  Application
//
//  Created by Samuel Brasileiro on 25/05/23.
//

import Core
import ModuleIntegrator
import Store
import UIKit

public class SceneDelegate: CoreSceneDelegate {
    public override func setupEnvironment() {
        let navigationController = UINavigationController()
        let resolver = ApplicationIntegrator.build()
        let coordinator = StoreCoordinator(resolver: resolver,
                                          navigationController: navigationController)
        coordinator.delegate = self
        coordinator.start()
        self.coordinator = coordinator
    }
}

extension SceneDelegate: StoreCoordinatorDelegate { }
