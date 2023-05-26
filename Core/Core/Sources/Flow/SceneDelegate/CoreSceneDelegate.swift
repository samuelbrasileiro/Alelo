//
//  CoreSceneDelegate.swift
//  Core
//
//  Created by Samuel Brasileiro on 26/05/23.
//

import UIKit

open class CoreSceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    public var window: UIWindow?
    
    public var coordinator: (any Coordinator)?
    
    public func scene(_ scene: UIScene,
                      willConnectTo session: UISceneSession,
                      options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        setupEnvironment()
        window.rootViewController = coordinator?.navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
    
    open func setupEnvironment() { }
}
