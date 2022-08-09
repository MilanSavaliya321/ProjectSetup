//
//  SceneDelegate.swift
//  Test
//
//  Created by PC on 05/04/22.
//

import UIKit
import SwiftUI

enum RootVCType {
    case onboard
    case login
    case home
    case custom(viewController: UIViewController)
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private(set) static var shared: SceneDelegate?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        guard let _ = (scene as? UIWindowScene) else { return }
        Self.shared = self
        if AccountManager.shared.isFirstTimeVisit() {
            if AccountManager.shared.isLoggedIn() {
                showViewController(.home)
            } else {
                showViewController(.login)
            }
        } else {
            UserDefaults.standard.set(true, forKey: "isFirstTimeVisit")
            showViewController(.onboard)
        }
    }

    func showViewController(_ vc: RootVCType, fromLogin: Bool = false) {
        guard let window = self.window else { return }
        let loginVC = UINavigationController(rootViewController: UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as! ViewController)
        
        switch vc {
        case .login:
            window.rootViewController = loginVC
        case .onboard:
            window.rootViewController = loginVC
        case .home:
            window.rootViewController = loginVC
        case .custom(let viewController):
            window.rootViewController = viewController
        }
        
        window.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

