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


typealias NotificationClosure = (Notification)->()
typealias ClosureToBool = ()->(Bool)
typealias ClosureWithString = (String)->()


func backgroundQueue(closure:@escaping Block) {
    DispatchQueue.global(qos: .default).async(execute: closure)
}

func mainQueue(closure:@escaping Block) {
    DispatchQueue.main.async(execute: closure)
}

func delay(_ seconds: Double, closure:@escaping Block) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: closure)
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



