//
//  SelfieCameraController.swift
//  Skyline
//
//  Created by Sean Orelli on 7/11/18.
//  Copyright © 2018 Fuzz. All rights reserved.
//

import UIKit
import AVKit
import Vision

/*______________________________________________________

			Selfie Camera Controller
______________________________________________________*/
class SelfieCameraController: CameraController
{
	override func createModel() -> CameraModel {
		return SelfieCameraModel()
	}
}
