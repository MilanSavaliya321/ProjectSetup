//
//  AppDelegate+Extension.swift
//  Test
//
//  Created by PC on 05/07/22.
//

import UIKit

extension AppDelegate {
    
    // MARK: - Check Internet Reacheblity
    func setupInternetReacheblity() {
        do {
            reachability = try? Reachability()
            if reachability != nil {
                reachability?.whenReachable = { reachability in
                    DLog("reachable")
                    if self.isNoInternetViewPresent, let topVC = UIApplication.getTopViewController(),
                       topVC.isKind(of: NoInternetConnection.self) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.isNoInternetViewPresent = false
                            // Utility.windowMain()?.rootViewController = tabBarVC
                        }
                    }
                }
                reachability?.whenUnreachable = { _ in
                    DLog("Not reachable")
                    if let topViewController = UIApplication.getTopViewController(), !topViewController.isKind(of: NoInternetConnection.self) {
                        let noInternetViewController = NoInternetConnection()
                        noInternetViewController.modalPresentationStyle = .overFullScreen
                        topViewController.present(noInternetViewController, animated: true, completion: {
                            self.isNoInternetViewPresent = true
                        })
                    }
                }
                try reachability?.startNotifier()
            }
        }catch {
            DLog("error in setup Reachability", error.localizedDescription)
        }
    }
    
    
}

