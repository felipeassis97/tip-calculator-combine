//
//  SceneDelegate.swift
//  tip-Calculator
//
//  Created by Felipe Assis on 03/03/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let customWindow = UIWindow(windowScene: windowScene)
        
        let vc = CalculatorVC()
        customWindow.rootViewController = vc
        self.window = customWindow
        customWindow.makeKeyAndVisible()
    }
}

