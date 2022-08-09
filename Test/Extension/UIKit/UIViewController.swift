//
//  UIViewController.swift
//  Test
//
//  Created by PC on 04/07/22.
//

import Foundation
import UIKit

extension UIViewController {
    func showErrorAlert(_ message: String?, action: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(_ message: String?, okTitle: String, action: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
