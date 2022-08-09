//
//  Utils+Extension.swift
//  Test
//
//  Created by PC on 04/07/22.
//

import Foundation
import LocalAuthentication

// MARK: Biometric
extension Utils {
    
    enum BiometricType {
        case none
        case touch
        case face
    }
    
    func getDeviceBiometricType() -> BiometricType {
        let authContext = LAContext()
        _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch(authContext.biometryType) {
        case .none:
            return .none
        case .touchID:
            return .touch
        case .faceID:
            return .face
        @unknown default:
            return .none
        }
    }
}

// MARK: Extra Function
extension Utils {
    class func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
