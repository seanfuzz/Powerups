//
//  Closure.swift
//  Powerups
//
//  Created by Sean Orelli on 11/30/18.
//  Copyright © 2018 Sean Orelli. All rights reserved.
//

import UIKit

import AVKit
import ImageIO
import CoreML
import Vision

typealias Closure = ()->()
typealias NotificationClosure = (Notification)->()
typealias ClosureToBool = ()->(Bool)
typealias ClosureWithString = (String)->()


func backgroundQueue(closure:@escaping Closure) {
    DispatchQueue.global(qos: .default).async(execute: closure)
}

func mainQueue(closure:@escaping Closure) {
    DispatchQueue.main.async(execute: closure)
}

func delay(_ seconds: Double, closure:@escaping Closure) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: closure)
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

extension CGImagePropertyOrientation {
    /**
     Converts a `UIImageOrientation` to a corresponding
     `CGImagePropertyOrientation`. The cases for each
     orientation are represented by different raw values.
     
     - Tag: ConvertOrientation
     */
    init(_ orientation: UIImage.Orientation) {
        switch orientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        }
    }
}


extension AVCaptureDevice
{
    func highestResolution420Format() -> (format: AVCaptureDevice.Format, resolution: CGSize)?
    {
        var highestResolutionFormat: AVCaptureDevice.Format? = nil
        var highestResolutionDimensions = CMVideoDimensions(width: 0, height: 0)
        
        for format in self.formats
        {
            let deviceFormat = format as AVCaptureDevice.Format
            
            let deviceFormatDescription = deviceFormat.formatDescription
            
            if CMFormatDescriptionGetMediaSubType(deviceFormatDescription) == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
            {
                let candidateDimensions = CMVideoFormatDescriptionGetDimensions(deviceFormatDescription)//.videoDimensions
                if (highestResolutionFormat == nil) || (candidateDimensions.width > highestResolutionDimensions.width)
                {
                    highestResolutionFormat = deviceFormat
                    highestResolutionDimensions = candidateDimensions
                }
            }
        }
        
        if highestResolutionFormat != nil
        {
            let resolution = CGSize(width: CGFloat(highestResolutionDimensions.width), height: CGFloat(highestResolutionDimensions.height))
            return (highestResolutionFormat!, resolution)
        }
        
        return nil
    }
}


extension UIDeviceOrientation
{
    var exifOrientation: CGImagePropertyOrientation
    {
        switch self
        {
        case .portraitUpsideDown: return .rightMirrored
        case .landscapeLeft: return .downMirrored
        case .landscapeRight: return .upMirrored
        default: return .leftMirrored
        }
    }
}



extension CGFloat
{
    func convertedToRadians() -> CGFloat
    {
        return CGFloat(Double(self) * Double.pi / 180.0)
    }
}


extension UIViewController
{
    // MARK: Helper Methods for Error Presentation
    func presentErrorAlert(withTitle title: String = "Unexpected Failure", message: String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alertController, animated: true)
    }
    
    func presentError(_ error: NSError)
    {
        self.presentErrorAlert(withTitle: "Failed with error \(error.code)", message: error.localizedDescription)
    }
    
}
