import Foundation
import UIKit

extension UISegmentedControl {
    
    
    @IBInspectable
    var SelectedColor: UIColor {
        get {
           return self.SelectedColor
        }
        set {
            var attributes = self.titleTextAttributes(for: state) ?? [:]
            attributes[.foregroundColor] = newValue
            self.setTitleTextAttributes(attributes, for: .selected)
        }
    }
    
    
    @IBInspectable
    var UnSelectedColor: UIColor {
        get {
            return self.UnSelectedColor
        }
        set {
            var attributes = self.titleTextAttributes(for: state) ?? [:]
            attributes[.foregroundColor] = newValue
            self.setTitleTextAttributes(attributes, for: .normal)
        }
    }
    
    @IBInspectable
    var fontSize: Float {
        get {
            return self.fontSize
        }
        set {
            var attributes = self.titleTextAttributes(for: state) ?? [:]
            attributes[.font] = UIFont.systemFont(ofSize: CGFloat(newValue))
            self.setTitleTextAttributes(attributes, for: state)
        }
    }
    
}
