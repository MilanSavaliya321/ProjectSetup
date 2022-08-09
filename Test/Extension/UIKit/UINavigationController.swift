//
//  UINavigationController.swift
//  Test
//
//  Created by PC on 04/07/22.
//

import Foundation
import UIKit

// MARK: - Enable swipe to back.
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

extension UINavigationController {
    
    func removeViewController(_ controller: UIViewController.Type) {
        if let viewController = viewControllers.first(where: { $0.isKind(of: controller.self) }) {
            viewController.removeFromParent()
        }
    }
}

extension UINavigationController {

    ///Hide navigation bar with Animation
    func hideNavigationBar(){
        self.setNavigationBarHidden(true, animated: true)
    }
    ///Show navigation bar with Animation
    func showNavigationBar() {
        self.setNavigationBarHidden(false, animated: true)
    }
    
    ///For Transparent Naviagation bar
    func setTransparentNaviagationBar(){
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.isTranslucent = true
    }
    
    /// Set Clear navigation Bar
    func setClearNavaigationBar(){
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
    }
}
