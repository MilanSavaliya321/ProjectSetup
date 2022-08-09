//
//  Utils.swift
//  Test
//
//  Created by PC on 30/06/22.
//

import Foundation
import UIKit

class Utils {
    
    static let shared = Utils()
    private static var loadingCount = 0
    
    class func getAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    class func getSceneDelegate() -> SceneDelegate? {
        guard let delegate = UIApplication.shared.connectedScenes.first else { return nil }
        return delegate.delegate as? SceneDelegate ?? nil
    }
    
    class func getWindowMain() -> UIWindow? {
        return SceneDelegate.shared?.window
    }
    
    class func getRootViewController() -> UIViewController? {
        return self.getWindowMain()?.rootViewController
    }
    
    class func getApplication() -> UIApplication {
        return UIApplication.shared
    }
    
    class func setFontSizeAsPerDeviceHeight(currentSize : CGFloat) -> CGFloat {
        let size = currentSize * UIScreen.main.bounds.height / 812
        return size
    }
    
}

// MARK: Loader
extension Utils {
    
    class func showLoader() {
        if loadingCount == 0 {
            // Show loader
        }
        loadingCount += 1
    }
    
    class func hideLoader() {
        if loadingCount > 0 {
            loadingCount -= 1
        }
        if loadingCount == 0 {
            // Hide loader
        }
    }
}
