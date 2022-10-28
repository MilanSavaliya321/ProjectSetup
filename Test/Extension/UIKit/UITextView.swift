
import Foundation
import UIKit

extension UITextView {

    /// Set TextView Height Accourding to Content
    func setTextViewHeight() {
        self.translatesAutoresizingMaskIntoConstraints = true
        self.sizeToFit()
        self.isScrollEnabled = false
    }

    func underlined() {
        self.attributedText = NSMutableAttributedString(string: self.text, attributes: [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue])
    }
}
