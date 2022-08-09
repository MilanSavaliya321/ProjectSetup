//
//  URL.swift
//  Test
//
//  Created by PC on 30/06/22.
//

import Foundation
import UIKit
import AVFoundation
import MobileCoreServices

extension URL {
    
    func appending(_ urlQueryItems: [URLQueryItem]) -> URL {
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        for item in urlQueryItems {
            queryItems.append(item)
        }
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
    
}

extension URL {
    
    func thumbnailForVideo() -> UIImage? {
        let asset = AVURLAsset(url: self)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        do {
            let cgImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func fileSize() -> Double {
        var fileSize: Double = 0.0
        var fileSizeValue = 0.0
        try? fileSizeValue = (self.resourceValues(forKeys: [URLResourceKey.fileSizeKey]).allValues.first?.value as! Double?)!
        if fileSizeValue > 0.0 {
            fileSize = (Double(fileSizeValue) / (1024 * 1024))
        }
        return fileSize
    }
    
    var isDirectory: Bool {
       return (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
}
