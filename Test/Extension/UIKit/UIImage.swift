import Foundation
import UIKit

public extension UIImage {
    /**
     Suitable size for specific height or width to keep same image ratio
     */
  
    func suitableSize(heightLimit: CGFloat? = nil,
                      widthLimit: CGFloat? = nil )-> CGSize? {
        if let height = heightLimit {
            let width = (height / self.size.height) * self.size.width
            return CGSize(width: width, height: height)
        }
        if let width = widthLimit {
            let height = (width / self.size.width) * self.size.height
            return CGSize(width: width, height: height)
        }
        return nil
    }
  /*
    func setImage(image: UIImage) {
        imageView.image = image
        let size = image.suitableSize(widthLimit: UIScreen.main.bounds.width)
        imageViewHeightConstraint.constant = (size?.height)!
    }
  */
}

extension UIImage {
    
    func isEqual(to image: UIImage) -> Bool {
        guard let data1: Data = self.pngData(),
              let data2: Data = image.pngData() else {
            return false
        }
        return data1.elementsEqual(data2)
    }
    
}
