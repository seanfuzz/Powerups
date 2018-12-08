/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Contains the main app implementation using Vision.
*/

import UIKit
import AVKit
import Vision

/*____________________________________________________________

					Camera  Controller
____________________________________________________________*/
class CameraController: ViewController, CameraModelDelegate
{
 	lazy var model: CameraModel = {
		createModel()
	}()

	func createModel() -> CameraModel {
		return CameraModel()
	}


    @IBOutlet weak var previewView: CameraView? // CameraView

    // Ensure that the interface stays locked in Portrait.
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        return .portrait
    }

    // Ensure that the interface stays locked in Portrait.
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation
    {
        return .portrait
    }

	override func viewDidLoad()
    {
        super.viewDidLoad()

    	model.setupSession()
		previewView?.configurePreview(model:model)
		model.session?.startRunning()
    }



   	// Removes infrastructure for AVCapture as part of cleanup.
	func teardownAVCapture()
    {
    	model.teardownAVCapture()
		previewView?.teardownAVCapture()
    }

    
	public func processPixels(sampleBuffer: CMSampleBuffer)
	{

	}
}

