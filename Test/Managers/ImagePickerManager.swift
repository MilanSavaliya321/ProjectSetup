//
//  ImagePickerManager.swift
//  Test
//
//  Created by PC on 05/07/22.
//

import Foundation
import UIKit

/* Use
 ImagePickerManager.shared.pickImage(on: self, withOption: [.photos,.camera]) { image in
     
 }
*/

class ImagePickerManager: NSObject {

  private var imagePicker = UIImagePickerController()
  private var viewController: UIViewController?
  private var didFinishPickingMedia : ((UIImage) -> ())?
  private var pickerTypes: [PickingOption] = [.photos]

  enum PickingOption {
    case camera
    case photos
  }

  static let shared = ImagePickerManager()

  private override init() {
    super.init()
  }

  func configureAndShowAlerts() {
      let pickerAlert = UIAlertController(title: "CHOOSE_IMAGE_FROM", message: nil, preferredStyle: .actionSheet)
    if pickerTypes.contains(.camera) {
        let cameraAction = UIAlertAction(title: "PROFILE_CAMERA", style: .default) { UIAlertAction in
        self.openCamera()
      }
      pickerAlert.addAction(cameraAction)
    }

    if pickerTypes.contains(.photos) {
        let photosAction = UIAlertAction(title: "PHOTOS", style: .default) { UIAlertAction in
        self.openPhotos()
      }
      pickerAlert.addAction(photosAction)
    }

      let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel)
    pickerAlert.addAction(cancelAction)

    viewController?.present(pickerAlert, animated: true, completion: nil)
  }

  func pickImage(on viewController: UIViewController, withOption: [PickingOption], _ didFinishPickingMedia: @escaping ((UIImage) -> ())) {
    self.didFinishPickingMedia = didFinishPickingMedia
    self.pickerTypes = withOption
    self.viewController = viewController
    imagePicker.delegate = self
    if withOption.count == 1 {
      if withOption.first == .camera { openCamera() }
      if withOption.first == .photos { openPhotos() }
      return
    }
    configureAndShowAlerts()
  }

  private func openCamera() {
    if (UIImagePickerController .isSourceTypeAvailable(.camera)) {
      imagePicker.sourceType = .camera
      self.viewController?.present(imagePicker, animated: true, completion: nil)
    }
  }

  private func openPhotos() {
    imagePicker.sourceType = .photoLibrary
    self.viewController?.present(imagePicker, animated: true, completion: nil)
  }

}

extension ImagePickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      
      
    picker.dismiss(animated: true, completion: nil)
    guard let image = info[.originalImage] as? UIImage else {
      fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
    }
    didFinishPickingMedia?(image)
  }

}
