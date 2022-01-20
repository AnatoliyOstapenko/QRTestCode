//
//  ViewController.swift
//  QRTestCode
//
//  Created by MacBook on 20.01.2022.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var video = AVCaptureVideoPreviewLayer()
    let session = AVCaptureSession() // Set session
    
    @IBOutlet weak var startVideoButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        startVideoButton.layer.cornerRadius = 25.0
        
        setupVideo()
    }
    
    func setupVideo() {
            
        // Set video device
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return print("error with capture device") }
        
        // Set input
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        } catch { fatalError(debugDescription) }
        
        // Set output
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        // set video
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds // set view bounds up to total screen
    }
    
    
    func startVideo() {
        view.layer.addSublayer(video)
        session.startRunning()
        
    }

    @IBAction func startVideoButtonPressed(_ sender: UIButton) {
        
        startVideo()
    }
    
}

