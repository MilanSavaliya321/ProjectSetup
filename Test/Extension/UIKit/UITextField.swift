//
//  UITextField.swift
//  Test
//
//  Created by PC on 30/06/22.
//

import Foundation
import UIKit

extension UITextField {
    
    func setLeftPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setPlaceHolderTextColor(_ color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
    
    func setRightViewForTextField(viewImage: UIImage, action: Selector?) {
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 29))
        let button = UIButton()
        button.setImage(viewImage, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: self.frame.size.height*0.6, height: self.frame.size.height*0.6)
        if let targetAction = action {
            button.addTarget(self, action: targetAction, for: .touchUpInside)
        }
        rightView.addSubview(button)
        self.rightView = rightView
        self.rightViewMode = .always
    }
}

extension UITextField {

    public func addImageToRightSide(image: UIImage, width: CGFloat) {
        let tempView = UIView()
        tempView.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.height)
        tempView.isUserInteractionEnabled = false
        
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.height)
        imageView.contentMode = .center
        imageView.image = image
        
        tempView.addSubview(imageView)

        self.rightView = tempView
        self.rightViewMode = .always
    }
    
    public func addImageToLeftSide(image: UIImage, width: CGFloat) {
        let tempView = UIView()
        tempView.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.height)
        tempView.isUserInteractionEnabled = false
        
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.height)
        imageView.contentMode = .center
        imageView.image = image
        
        tempView.addSubview(imageView)
        
        self.leftView = tempView
        self.leftViewMode = .always
    }
}
