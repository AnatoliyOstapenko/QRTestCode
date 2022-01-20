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
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        startVideoButton.layer.cornerRadius = 25.0
        cancelBarButton.isEnabled = false
 
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
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        
        // set video
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds // set view bounds up to total screen
    }
    
    
    func startVideo() {
        
        view.layer.addSublayer(video)
        session.startRunning()
        
    }
    
    func stopVideo() {
        view.layer.sublayers?.removeLast() // escape from video screen
        session.stopRunning() // stop session
    }

    @IBAction func startVideoButtonPressed(_ sender: UIButton) {
        cancelBarButton.isEnabled = true
        startVideo()
        
    }
  
    
    @IBAction func cancelBarButtonPressed(_ sender: UIBarButtonItem) {
        cancelBarButton.isEnabled = false
        stopVideo()
        

    }
    
}

// MARK:- AVCaptureMetadataOutputObjectsDelegate Reading QR Code Method
extension ViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    // it happens when QR code detected
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        print("metadataObjects = \(metadataObjects.count)")
        
        guard metadataObjects.count > 0 else { return }
        
        if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if object.type == AVMetadataObject.ObjectType.qr {
                
                guard let urlString  = object.stringValue else { return }
                
                let alert = UIAlertController(title: "QR Code", message: object.stringValue, preferredStyle: .alert)
                let goTo = UIAlertAction(title: "Go to...", style: .default) { (action) in
                    print("object.stringValue = \(urlString)") // url string
                }
                let copy = UIAlertAction(title: "Copy...", style: .default) { (action) in
                    
                    // Copy url string to use everywhere
                    UIPasteboard.general.string = object.stringValue
                    
                    self.stopVideo()
                }
                alert.addAction(goTo)
                alert.addAction(copy)
                
                present(alert, animated: true, completion: nil)
                
            }
        }
        
    
    }
}

