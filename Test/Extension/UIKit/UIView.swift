//
//  UIView.swift
//  Test
//
//  Created by PC on 30/06/22.
//

import Foundation
import UIKit

extension UIView {
    class func initiate<T: UIView>() -> T? {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?[0] as? T
    }
    
    class func fromNib<T: UIView>() -> T? {
        let nib = UINib(nibName: String(describing: T.self), bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil)[0] as? T
    }
    
    func addSubViewWithAutolayout(subView: UIView?) {
        guard let subView = subView else { return }
        self.addSubview(subView)
        
        subView.translatesAutoresizingMaskIntoConstraints = false
        
        subView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        subView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        subView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        subView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        subView.layoutIfNeeded()
        self.layoutIfNeeded()
    }
    
    func setRoundedView() {
        self.layer.cornerRadius = min(self.frame.width, self.frame.height) / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
    }
    
    func addDashedBorder(color: UIColor = UIColor.red, lineDashPattern: [NSNumber]? = [4,4]) {
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        shapeLayer.bounds = shapeRect
        shapeLayer.name = "DashBorder"
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 1.5
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = lineDashPattern
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 10).cgPath
        self.layer.masksToBounds = false
        self.layer.addSublayer(shapeLayer)
    }

    func removeDeshBorder() {
        _ = self.layer.sublayers?.filter({$0.name == "DashBorder"}).map({$0.removeFromSuperlayer()})
    }

    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.shadowColor?.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 0.5)
        layer.shadowRadius = 8
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
    func removeShadow() {
        self.layer.shadowOffset = CGSize(width: 0 , height: 0)
        self.layer.shadowColor = UIColor.clear.cgColor
        self.layer.cornerRadius = 0.0
        self.layer.shadowRadius = 0.0
        self.layer.shadowOpacity = 0.0
    }
}

extension UIView {
    
    public func addTapAction(action: @escaping () -> Void) {
        let tapGesture = UITapGestureRecognizer { _ in
            action()
        }
        self.isUserInteractionEnabled = true
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
    }
}

extension UIGestureRecognizer {
    
    typealias Action = ((UIGestureRecognizer) -> ())
    
    private struct Keys {
        static var actionKey = "ActionKey"
    }
    
    private var block: Action? {
        get {
            let action = objc_getAssociatedObject(self, &Keys.actionKey) as? Action
            return action
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &Keys.actionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
    }
    
    @objc func handleAction(recognizer: UIGestureRecognizer) {
        if recognizer.state == .ended {
            block?(recognizer)
            recognizer.isEnabled = false
            recognizer.cancelsTouchesInView = true
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                recognizer.isEnabled = true
                recognizer.cancelsTouchesInView = false
            }
        }
    }
    
    convenience public init(block: @escaping ((UIGestureRecognizer) -> ())) {
        self.init()
        self.block = block
        self.addTarget(self, action: #selector(handleAction(recognizer:)))
    }
}

extension UIView {
    /**
     Convert UIView to UIImage
     */
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        let snapshotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImageFromMyView!
    }
}
