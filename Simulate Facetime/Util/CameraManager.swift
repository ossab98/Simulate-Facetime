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
    
    var isCameraSupported: Bool {
        if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
            // Device has a camera
            DispatchQueue.main.async {
                self.openVideocamera(position: .front)
            }
            return true
        }else{
            // Device hasn't a camera!
            DispatchQueue.main.async {
                self.previewLayer.removeFromSuperlayer()
            }
            return false
        }
    }
    
    func checkCameraPrmissions(onRequested: @escaping((Bool)->()) ) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .notDetermined:
            // Request
            AVCaptureDevice.requestAccess(for: .video) { granted in
                guard granted else { onRequested(false); return }
                onRequested(true)
            }
        case .denied:
            onRequested(false)
        case .authorized:
            onRequested(true)
        default:
            break
        }
    }
    
    func openVideocamera(position: AVCaptureDevice.Position){
        self.checkCameraPrmissions() { [weak self] isGranted in
            if isGranted == true {
                self?.addVideoInput(position: position)
            }
        }
    }
    
    private func addVideoInput(position: AVCaptureDevice.Position) {
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
        
        DispatchQueue.global(qos: .background).async {
            self.previewLayer.videoGravity = .resizeAspectFill
            self.previewLayer.session = session
            self.session = session
            self.session?.startRunning()
        }
    }
    
}
