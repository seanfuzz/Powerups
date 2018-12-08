//
//  SelfieCameraModel.swift
//  Skyline
//
//  Created by Sean Orelli on 7/20/18.
//  Copyright © 2018 Fuzz. All rights reserved.
//
import UIKit
import AVKit
import Vision

class SelfieCameraModel: CameraModel
{
	override func configureInput()
    {
		guard let session = session else { return }

		let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front)

		if let device = deviceDiscoverySession.devices.first
		{
			if let deviceInput = try? AVCaptureDeviceInput(device: device)
			{
				if session.canAddInput(deviceInput)
				{
					session.addInput(deviceInput)
				}

				if let highestResolution = device.highestResolution420Format()
				{
					try? device.lockForConfiguration()
					device.activeFormat = highestResolution.format
					device.unlockForConfiguration()

					captureDevice = device
					captureDeviceResolution = highestResolution.resolution
				}
			}
		}
    }

 	override func configureOutput()
    {
    	//guard let inputDevice = captureDevice else { return }
		guard let session = session else { return }

		let videoDataOutput = AVCaptureVideoDataOutput()
		videoDataOutput.alwaysDiscardsLateVideoFrames = true

		// Create a serial dispatch queue used for the sample buffer delegate as well as when a still image is captured.
		// A serial dispatch queue must be used to guarantee that video frames will be delivered in order.
		let videoDataOutputQueue = DispatchQueue(label: "com.fuzz.capturecontroller")
		videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)

		self.videoDataOutput = videoDataOutput
		self.videoDataOutputQueue = videoDataOutputQueue

		if session.canAddOutput(videoDataOutput)
		{
			session.addOutput(videoDataOutput)
		}

		videoDataOutput.connection(with: .video)?.isEnabled = true

		if let captureConnection = videoDataOutput.connection(with: AVMediaType.video)
		{
			if captureConnection.isCameraIntrinsicMatrixDeliverySupported
			{
				captureConnection.isCameraIntrinsicMatrixDeliveryEnabled = true
			}
		}
    }
}
