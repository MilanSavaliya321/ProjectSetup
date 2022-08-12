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

// MARK: - localToUTC and utcToLocal
extension Utils {
    
    class func localToUTC(dateStr: String, fromFormat: String = "dd MMM y h:mm a", toFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SS'Z'") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone.current
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = toFormat
            
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    class func utcToLocal(dateStr: String, fromFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SS'Z'", toFormat: String = "dd MMM y h:mm a") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = toFormat
            
            return dateFormatter.string(from: date)
        }
        return nil
    }
}

