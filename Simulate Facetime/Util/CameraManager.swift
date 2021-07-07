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
    
    var isCameraActive: Bool = false
    var isCameraSupported: Bool {
        if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
            // Device has a camera
            DispatchQueue.main.async {
                CameraManager.shared.checkCameraPrmissions(position: .front)
            }
            return true
        }else{
            // Device hasn't a camera!
            DispatchQueue.main.async {
                CameraManager.shared.previewLayer.removeFromSuperlayer()
            }
            return false
        }
    }
    
    func checkCameraPrmissions(position: AVCaptureDevice.Position) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .notDetermined:
            // Request
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else { return }
                DispatchQueue.main.async {
                    self?.isCameraActive = true
                    self?.addVideoInput(position: position)
                }
            }
        case .denied:
            self.isCameraActive = false
        case .authorized:
            self.isCameraActive = true
            addVideoInput(position: position)
        default:
            break
        }
    }
    
    func addVideoInput(position: AVCaptureDevice.Position) {
        let session = AVCaptureSession()
        let devices = AVCaptureDevice.devices(for: .video)
        let frontCamIndex = 1
        let backCamIndex = 0
        let positionIndex = position == .front ? frontCamIndex : backCamIndex
        do {
            let input = try AVCaptureDeviceInput(device: devices[positionIndex])
            if session.canAddInput(input) {
                session.addInput(input)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        DispatchQueue.main.async {
            self.previewLayer.videoGravity = .resizeAspectFill
            self.previewLayer.session = session
            self.session = session
            self.session?.startRunning()
        }
    }
    
}
