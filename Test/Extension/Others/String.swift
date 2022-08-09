//
//  String.swift
//  Test
//
//  Created by PC on 30/06/22.
//

import Foundation
import UIKit

extension String {

    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }

    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}


extension String {
    
    func checkRegex(for pattern: String) -> Bool {
        let passwordRegex = pattern
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }

    func trimWithOneSpace() -> String {
        var isLastCharisSpace = false
        var finalStr = ""
        let arrStr = self.trimmingCharacters(in: .whitespacesAndNewlines).map { String($0) }

        for i in arrStr {
            if i == " " && isLastCharisSpace == false {
                isLastCharisSpace = true
                finalStr = finalStr + i
            } else {
                if i != " " {
                    isLastCharisSpace = false
                    finalStr = finalStr + i
                }
            }
        }
        return finalStr
    }
}

extension String {
        
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }

    public var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    public func toInt() -> Int? {
        let formatter =  NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        if let num = formatter.number(from: self) {
            return num.intValue
        } else {
            return nil
        }
    }
    
    /// EZSE: Converts String to Bool
    public func toBool() -> Bool? {
        return (self as NSString).boolValue
    }
    
    /// EZSE: Trims white space and new line characters
    public mutating func trim() {
        self = self.trimmed()
    }
    
    /// EZSE: Trims white space and new line characters, returns a new string
    public func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}

extension String {
    
    func fileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }
    
    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
}

extension String {
    func isLetterOrisNumber() -> Bool {
        if self.isEmpty {
            return true
        }
        var arr = [Character]()
        for char in self {
            arr.append(char)
        }
        if (arr[0].isNumber) {
            return true
        }
        else if (arr[0].isLetter) {
            return true
        } else {
            return false
        }
    }
}
