//
//  UIApplication.swift
//  Test
//
//  Created by PC on 01/07/22.
//

import Foundation
import UIKit

extension UIApplication {
    
    static func getTopViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        var topController: UIViewController? = keyWindow?.rootViewController
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        return topController
    }
    
     class func rootViewController() -> UIViewController? {
         return UIApplication.shared.connectedScenes
                 .filter({$0.activationState == .foregroundActive})
                 .compactMap({$0 as? UIWindowScene})
                 .first?.windows
                 .filter({$0.isKeyWindow}).first?.rootViewController
     }
}
