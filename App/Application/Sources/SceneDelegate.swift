//
//  SceneDelegate.swift
//  Application
//
//  Created by Samuel Brasileiro on 25/05/23.
//

import UIKit

open class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    public var window: UIWindow?
        
    public func scene(_ scene: UIScene,
                      willConnectTo session: UISceneSession,
                      options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        window.rootViewController = UINavigationController()
        self.window = window
        window.makeKeyAndVisible()
    }
}
