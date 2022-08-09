//
//  AccountManager.swift
//  Test
//
//  Created by PC on 30/06/22.
//

import Foundation

struct AccountManager {
    static let shared = AccountManager()
    
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    func isFirstTimeVisit() -> Bool {
        return UserDefaults.standard.bool(forKey: "isFirstTimeVisit")
    }
    
    func getFirebaseToken() -> String? {
        return ""
    }
    
    func getUserFullName() -> String? {
        return ""
    }
    
    func getUserEmail() -> String? {
        return ""
    }
    
    func logOut() {
        Utils.getSceneDelegate()?.showViewController(.login)
    }
}

