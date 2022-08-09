//
//  UIButton.swift
//  Test
//
//  Created by PC on 04/07/22.
//


import Foundation
import UIKit

extension UIButton {

    public func setUnderlineButton() {
        let text = self.titleLabel?.text
        let titleString = NSMutableAttributedString(string: text!)
        titleString.addAttributes([NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue], range: NSMakeRange(0, (text?.count)!))
        self.setAttributedTitle(titleString, for: .normal)
    }
}
