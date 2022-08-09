//
//  UILabel.swift
//  Test
//
//  Created by PC on 04/07/22.
//

import Foundation

import UIKit

extension UILabel {

    func setLineSpacing(lineSpacing: CGFloat = 4.0, lineHeightMultiple: CGFloat = 0.0, alignment: NSTextAlignment = .left) {

        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.alignment = alignment
        let attributedString: NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        attributedString.addAttribute(.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
    }
}
