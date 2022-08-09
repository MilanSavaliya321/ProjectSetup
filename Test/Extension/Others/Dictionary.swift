//
//  Dictionary.swift
//  Test
//
//  Created by PC on 05/07/22.
//

import Foundation

extension Dictionary where Key == String, Value == Any {

    func prettyPrint() {
        print(self.prettify())
    }
    
    func prettify() -> String {
        var string: String = ""
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted){
            if let nstr = NSString(data: data, encoding: String.Encoding.utf8.rawValue){
                string = nstr as String
            }
        }
        return string
    }
}
