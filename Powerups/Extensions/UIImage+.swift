//
//  UIImage+Powerups.swift
//  Powerups
//
//  Created by Sean Orelli on 11/7/18.
//  Copyright © 2018 Sean Orelli. All rights reserved.
//

import UIKit
import Vision

extension UIImage {
    
    static func downsample(imageAt imageURL: URL, to pointSize: CGSize, scale: CGFloat) -> UIImage? {
        let imageSourceOptions = [kCGImageSourceShouldCache: true] as CFDictionary
        let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions)!
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        let downsampleOptions =
            [kCGImageSourceCreateThumbnailFromImageAlways: true,
             kCGImageSourceShouldCacheImmediately: true,
             kCGImageSourceCreateThumbnailWithTransform: true,
             kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels] as CFDictionary
        
        if let downsampledImage =
            CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) {
            return UIImage(cgImage: downsampledImage)
        }
        return nil
    }
    
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
/*________________________________________________________________________________
 
 Apply a Classification Model to the image
 results return on the main thread
 ________________________________________________________________________________*/
public typealias VNClassificationHandler = ([VNClassificationObservation], Error?) -> Void
extension UIImage
{
    func classify(model:MLModel, completion: @escaping VNClassificationHandler)
    {
        do {
            let model_ = try VNCoreMLModel(for: model)
            classify(model: model_, completion:completion)
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }
    
    func classify(model:VNCoreMLModel, completion: @escaping VNClassificationHandler)
    {
        
        let request = VNCoreMLRequest(model: model){request, error in
            DispatchQueue.main.async {
                
                if let classifications = request.results as? [VNClassificationObservation]{
                    completion(classifications, error)
                }else {
                    completion([], error)
                }
            }
        }
        request.imageCropAndScaleOption = .centerCrop
        
        let orientation = CGImagePropertyOrientation(self.imageOrientation)
        guard let ciImage = CIImage(image: self) else { fatalError("Unable to create \(CIImage.self) from \(self).") }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([request])
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
}
