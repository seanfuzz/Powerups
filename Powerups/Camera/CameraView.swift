//
//  CamerView.swift
//  Skyline
//
//  Created by Sean Orelli on 7/20/18.
//  Copyright © 2018 Fuzz. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import Vision


/*________________________________________________________________

							Camera View
________________________________________________________________*/
class CameraView: UIView
{
	var previewLayer: AVCaptureVideoPreviewLayer?

	func configurePreview(model: CameraModel)
    {
    	if let session = model.session
    	{
			let previewLayer = AVCaptureVideoPreviewLayer(session: session)
			previewLayer.name = "CameraPreview"
			previewLayer.backgroundColor = UIColor.black.cgColor
			previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill

			layer.masksToBounds = true
			previewLayer.frame = layer.bounds
			layer.addSublayer(previewLayer)
			self.previewLayer = previewLayer
		}
    }

    func teardownAVCapture()
    {
		if let previewLayer = self.previewLayer
        {
            previewLayer.removeFromSuperlayer()
			self.previewLayer = nil
        }
    }
}

