//
//  CameraManager.swift
//  Simulate Facetime
//
//  Created by Ossama Abdelwahab on 02/07/21.
//

import UIKit
import AVFoundation

class CameraManager: NSObject {
    
    static let shared = CameraManager()
    
    // Capture Session
    var session: AVCaptureSession?
    // Video Preview
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    func checkCameraPrmissions(position: AVCaptureDevice.Position) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .notDetermined:
            // Request
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else { return }
                DispatchQueue.main.async {
                    self?.addVideoInput(position: position)
                }
            }
        case .restricted:
            // Denied access to camera
            print("Unable to access the Camera\nTo enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.")
            break
        case .authorized:
            addVideoInput(position: position)
        default:
            break
        }
    }
    
    func addVideoInput(position: AVCaptureDevice.Position) {
        let session = AVCaptureSession()
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position) else { return }
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.session = session
        
        self.session = session
        session.startRunning()
    }
    
}
