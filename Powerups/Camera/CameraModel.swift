//
//  CameraModel.swift
//  Skyline
//
//  Created by Sean Orelli on 7/20/18.
//  Copyright © 2018 Fuzz. All rights reserved.
//

import UIKit
import AVKit
import Vision

/*________________________________________________________________
 
 Camera Model
 ________________________________________________________________*/
protocol CameraModelDelegate //This could just be a closure
{
    func processPixels(sampleBuffer: CMSampleBuffer)
}

class CameraModel:NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate, CameraModelDelegate
{
    var delegate: CameraModelDelegate?
    
    var videoDataOutput: AVCaptureVideoDataOutput?
    var videoDataOutputQueue:DispatchQueue?
    var captureDevice: AVCaptureDevice?
    var captureDeviceResolution: CGSize = CGSize()
    var session: AVCaptureSession?
    var bufferSize: CGSize = .zero
    let metadataOutput = AVCaptureMetadataOutput()

    func setupSession()
    {
        let session = AVCaptureSession()
        self.session = session
        //These two calls should bookend configuration
        session.beginConfiguration()
        configureInput()
        configureOutput()
       /*
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            metadataOutput.metadataObjectTypes=metadataOutput.availableMetadataObjectTypes
            //                metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr, AVMetadataObject.ObjectType.upce]
        }*/

        session.commitConfiguration()

    }
    
    func configureInput()
    {
        
        guard let session = session else { return }
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back)
        
        if let device = deviceDiscoverySession.devices.first
        {
            if let deviceInput = try? AVCaptureDeviceInput(device: device)
            {
                session.sessionPreset = .vga640x480 // Model image size is smaller.
                
                if session.canAddInput(deviceInput)
                {
                    session.addInput(deviceInput)
                }
            }
            captureDevice = device
            
        }
    }
    
    
    func configureOutput()
    {
        if let session = session
        {
            //--------------- Output
            videoDataOutput = AVCaptureVideoDataOutput()
            videoDataOutputQueue = DispatchQueue(label: "com.fuzz.capturecontroller", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
            
            if session.canAddOutput(videoDataOutput!)
            {
                session.addOutput(videoDataOutput!)
                // Add a video data output
                videoDataOutput?.alwaysDiscardsLateVideoFrames = true
                videoDataOutput?.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
                videoDataOutput?.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
            } else
            {
                print("Could not add video data output to the session")
                return
            }            
            
            
            let captureConnection = videoDataOutput?.connection(with: .video)
            // Always process the frames
            captureConnection?.isEnabled = true
            do
            {
                if let videoDevice = captureDevice
                {
                    try  videoDevice.lockForConfiguration()
                    let dimensions = CMVideoFormatDescriptionGetDimensions(videoDevice.activeFormat.formatDescription)
                    bufferSize.width = CGFloat(dimensions.width)
                    bufferSize.height = CGFloat(dimensions.height)
                    videoDevice.unlockForConfiguration()
                }
            } catch
            {
                print(error)
            }
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection)
    {
        if let delegate = delegate{
            delegate.processPixels(sampleBuffer: sampleBuffer)
        }else{
            processPixels(sampleBuffer: sampleBuffer)
        }
    }
    
    func teardownAVCapture()
    {
        videoDataOutput = nil
        videoDataOutputQueue = nil
    }
    
    func processPixels(sampleBuffer: CMSampleBuffer)
    {
        
    }
    

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
        
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            if let string = readableObject.stringValue {
                print(string)
            }
        }
    }
}
