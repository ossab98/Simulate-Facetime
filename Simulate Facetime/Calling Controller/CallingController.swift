//
//  CallingController.swift
//  Simulate Facetime
//
//  Created by Ossama Abdelwahab on 04/07/21.
//

import UIKit
import AVFoundation

class CallingController: UIViewController {
    
    @IBOutlet weak var stackViewHeader: UIStackView!
    @IBOutlet weak var lblUserFullName: UILabel!
    @IBOutlet weak var lblCallType: UILabel!
    
    @IBOutlet weak var effectViewBackground: UIVisualEffectView!
    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var btnStopVideoCamera: UIButton!
    @IBOutlet weak var lblStopVideoCamera: UILabel!
    
    @IBOutlet weak var btnStartVideoCamera: UIButton!
    @IBOutlet weak var lblStartVideoCamera: UILabel!
    
    @IBOutlet weak var btnFlipCamera: UIButton!
    @IBOutlet weak var lblFlipCamera: UILabel!

    @IBOutlet weak var btnEndCall: UIButton!
    @IBOutlet weak var lblCloseCall: UILabel!
    
    private let lblErrorMessage: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .yellow
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 15
        return label
    }()
    
    private let blurEffect: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()
    
    // MARK: - Properties / Models
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        CameraManager.shared.previewLayer.frame = view.bounds
        blurEffect.frame = view.bounds
    }
}

// MARK:- Actions
extension CallingController{
    
    @IBAction func onStopCameraTapped(_ sender: UIButton) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        DispatchQueue.main.async {
            CameraManager.shared.session?.startRunning()
            CameraManager.shared.session?.stopRunning()
        }
    }
    
    @IBAction func onStartCameraTapped(_ sender: UIButton) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        DispatchQueue.main.async {
            CameraManager.shared.session?.startRunning()
        }
    }
    
    @IBAction func onFlipTapped(_ sender: UIButton) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            print(sender.isSelected)
            DispatchQueue.main.async {
                CameraManager.shared.checkCameraPrmissions(position: .back)
            }
        } else {
            print(sender.isSelected)
            DispatchQueue.main.async {
                CameraManager.shared.checkCameraPrmissions(position: .front)
            }
        }
    }
    
    @IBAction func onEndTapped(_ sender: UIButton) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK:- Func Helper
extension CallingController{
    
    func showErrorMessage(message: String){
        // ShowMessage with animate
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.lblErrorMessage.text = message
            UIView.animate(withDuration: 0.5, delay: 0.3, options: [], animations: { self.view.layoutIfNeeded() }, completion: nil)
        }
        // HideMessage with animate
        DispatchQueue.main.asyncAfter(deadline: .now() + 11) {
            UIView.animate(withDuration: 0.5, animations: {
                self.lblErrorMessage.alpha = 0
            }) { _ in
                self.lblErrorMessage.removeFromSuperview()
            }
        }
    }
    
    func authorizationStatus(){
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video)  {
        case .denied:
            // Denied access to camera
            showErrorMessage(message: "\nUnable to access the Camera\nTo enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.\n")
            deviceHasCameraActive(false)
        case .restricted:
            showErrorMessage(message: "\nUnable to access the Camera\nTo enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.\n")
            deviceHasCameraActive(false)
        default:
            break
        }
    }
}

// MARK:- SetUpView
extension CallingController{
    
    func setUpView(){
        
        // Set lblUserFullName
        lblUserFullName.text = user.name
        lblUserFullName.numberOfLines = 0
        
        // Set lblCallType
        lblCallType.text = "FaceTime..."
        lblCallType.numberOfLines = 1
        
        // Set effectViewBackground
        effectViewBackground.layer.masksToBounds = false
        effectViewBackground.clipsToBounds = true
        effectViewBackground.layer.cornerRadius = 20
        
        // Set btnStopVideoCamera
        btnStopVideoCamera.layer.masksToBounds = false
        btnStopVideoCamera.clipsToBounds = true
        btnStopVideoCamera.layer.cornerRadius = 20
        btnStopVideoCamera.contentMode = .scaleAspectFit
        btnStopVideoCamera.layer.borderWidth = 1
        btnStopVideoCamera.layer.borderColor = UIColor.lightGray.cgColor
        btnStopVideoCamera.backgroundColor = .darkGray
        
        // Set btnStartVideoCamera
        btnStartVideoCamera.layer.masksToBounds = false
        btnStartVideoCamera.clipsToBounds = true
        btnStartVideoCamera.layer.cornerRadius = 20
        btnStartVideoCamera.contentMode = .scaleAspectFit
        btnStartVideoCamera.layer.borderWidth = 1
        btnStartVideoCamera.layer.borderColor = UIColor.lightGray.cgColor
        btnStartVideoCamera.backgroundColor = .darkGray
        
        // Set btnFlipCamera
        btnFlipCamera.layer.masksToBounds = false
        btnFlipCamera.clipsToBounds = true
        btnFlipCamera.layer.cornerRadius = 20
        btnFlipCamera.contentMode = .scaleAspectFit
        btnFlipCamera.layer.borderWidth = 1
        btnFlipCamera.layer.borderColor = UIColor.lightGray.cgColor
        btnFlipCamera.backgroundColor = .darkGray
        
        // Set btnEndCall
        btnEndCall.layer.masksToBounds = false
        btnEndCall.clipsToBounds = true
        btnEndCall.layer.cornerRadius = 20
        btnEndCall.contentMode = .scaleAspectFit
        btnEndCall.layer.borderWidth = 1
        btnEndCall.layer.borderColor = UIColor.lightGray.cgColor
        btnEndCall.backgroundColor = .red
        
        // Check if the device has a camera to enable the videoCamera
        if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
            print("Device has camera")
            // Check Camera Prmissions & Add Video Input in Sublayer
            CameraManager.shared.checkCameraPrmissions(position: .front)
            view.layer.addSublayer(CameraManager.shared.previewLayer)
            deviceHasCameraActive(true)
        }else{
            print("Device hasn't camera!")
            // Remove Video Input from Sublayer
            CameraManager.shared.previewLayer.removeFromSuperlayer()
            showErrorMessage(message: "\nThe camera preview is not available on this device!\n")
            deviceHasCameraActive(false)
        }
        
        authorizationStatus()
        view.addSubview(stackViewHeader)
        view.addSubview(effectViewBackground)
    }
    
    func deviceHasCameraActive(_ cameraActive: Bool){
        if cameraActive == true {
            view.backgroundColor = .darkGray
            btnStopVideoCamera.isEnabled = true
            lblStopVideoCamera.alpha = 1
            btnStartVideoCamera.isEnabled = true
            lblStartVideoCamera.alpha = 1
            btnFlipCamera.isEnabled = true
            lblFlipCamera.alpha = 1
            blurEffect.removeFromSuperview()
            lblErrorMessage.removeFromSuperview()
        }else{
            view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "avatar-placeholder"))
            btnStopVideoCamera.isEnabled = false
            lblStopVideoCamera.alpha = 0.5
            btnStartVideoCamera.isEnabled = false
            lblStartVideoCamera.alpha = 0.5
            btnFlipCamera.isEnabled = false
            lblFlipCamera.alpha = 0.5
            view.addSubview(blurEffect)
            view.addSubview(lblErrorMessage)
            NSLayoutConstraint.activate([
                lblErrorMessage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                lblErrorMessage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                lblErrorMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
                lblErrorMessage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -155)
            ])
        }
    }
}
