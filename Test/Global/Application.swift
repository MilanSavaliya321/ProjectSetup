//
//  Application.swift
//  Test
//
//  Created by PC on 30/06/22.
//

import Foundation
import UIKit

struct Application {
    static let isDevelopmentMode = true
    static let debug: Bool = true
}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    open override var childForStatusBarStyle: UIViewController? {
        topViewController
    }
}

extension UIColor {
    static let mainBGColor              = UIColor(named: "MainBGColor")
    static let shadowColor              = UIColor(named: "ShadowColor")
}

enum FontName: String {
    case thin                                      = "Inter-Thin"
    case semiBold                                  = "Inter-SemiBold"
    case regular                                   = "Inter-Regular"
    case medium                                    = "Inter-Medium"
    case light                                     = "Inter-Light"
    case extraLight                                = "Inter-ExtraLight"
    case extraBold                                 = "Inter-ExtraBold"
    case bold                                      = "Inter-Bold"
}
