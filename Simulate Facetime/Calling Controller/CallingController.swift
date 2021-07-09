//
//  CallingController.swift
//  Simulate Facetime
//
//  Created by Ossama Abdelwahab on 04/07/21.
//

import UIKit

class CallingController: UIViewController {
    
    // header labels
    @IBOutlet private weak var stackViewHeader: UIStackView!
    @IBOutlet private weak var lblUserFullName: UILabel!
    @IBOutlet private weak var lblCallType: UILabel!
    // video camera controller
    @IBOutlet private weak var effectViewBackground: UIVisualEffectView!
    @IBOutlet private weak var lineView: UIView!
    // stop video camera
    @IBOutlet private weak var btnStopVideoCamera: UIButton!
    @IBOutlet private weak var lblStopVideoCamera: UILabel!
    // start video camera
    @IBOutlet private weak var btnStartVideoCamera: UIButton!
    @IBOutlet private weak var lblStartVideoCamera: UILabel!
    // flip video camera
    @IBOutlet private weak var btnFlipCamera: UIButton!
    @IBOutlet private weak var lblFlipCamera: UILabel!
    // end call
    @IBOutlet private weak var btnEndCall: UIButton!
    @IBOutlet private weak var lblEndCall: UILabel!
    
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
        return blurEffectView
    }()
    
    // MARK: - Properties / Models
    var user: User!
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    
    // viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpView()
    }
    
    // viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        CameraManager.shared.previewLayer.frame = view.bounds
        blurEffect.frame = view.bounds
    }
}

// MARK:- Actions
extension CallingController{
    
    @IBAction func onStopCameraTapped(_ sender: UIButton) {
        if #available(iOS 10.0, *) {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
        animateButtonClickA(buttonToAnimate: btnStopVideoCamera)
        DispatchQueue.global(qos: .background).async {
            CameraManager.shared.session?.stopRunning()
        }
    }
    
    @IBAction func onStartCameraTapped(_ sender: UIButton) {
        if #available(iOS 10.0, *) {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
        animateButtonClickA(buttonToAnimate: btnStartVideoCamera)
        DispatchQueue.global(qos: .background).async {
            CameraManager.shared.session?.startRunning()
        }
    }
    
    @IBAction func onFlipTapped(_ sender: UIButton) {
        if #available(iOS 10.0, *) {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
        animateButtonClickA(buttonToAnimate: btnFlipCamera)
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            DispatchQueue.main.async {
                CameraManager.shared.openVideocamera(position: .back)
            }
        } else {
            DispatchQueue.main.async {
                CameraManager.shared.openVideocamera(position: .front)
            }
        }
    }
    
    @IBAction func onEndTapped(_ sender: UIButton) {
        if #available(iOS 10.0, *) {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
        animateButtonClickA(buttonToAnimate: btnEndCall)
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK:- Func Helper
extension CallingController{
    
    func showErrorMessage(message: String){
        // ShowMessage with animate
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.lblErrorMessage.text = message
            UIView.animate(withDuration: 0.5, delay: 0.3, options: [], animations: { self?.view.layoutIfNeeded() }, completion: nil)
        }
        // HideMessage with animate
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) { [weak self] in
            UIView.animate(withDuration: 0.5, animations: {
                self?.lblErrorMessage.alpha = 0
            }) { _ in
                self?.lblErrorMessage.removeFromSuperview()
            }
        }
    }
    
    func deviceHasCameraActive(_ cameraActive: Bool){
        if cameraActive == true {
            view.backgroundColor = UIColor.black.withAlphaComponent(1.0)
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

// MARK:- SetUpView
extension CallingController{
    
    func setUpView(){
        setUpCamera()
        view.addSubview(stackViewHeader)
        view.addSubview(effectViewBackground)
    }
    
    func setUpCamera(){
        if CameraManager.shared.isCameraSupported == true {
            view.layer.addSublayer(CameraManager.shared.previewLayer)
            handleCameraSupported()
        } else {
            deviceHasCameraActive(false)
            showErrorMessage(message: "\nThe camera preview is not available on this device!\n")
        }
    }
    
    func handleCameraSupported(){
        CameraManager.shared.checkCameraPrmissions() { [weak self] isGranted in
            if isGranted == true {
                self?.deviceHasCameraActive(true)
            }else{
                self?.deviceHasCameraActive(false)
                self?.showErrorMessage(message: "\nUnable to access the Camera\nTo enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.\n")
            }
        }
    }
    
    func setUpUI(){
        
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
        
        // Set effectViewBackground
        lineView.layer.masksToBounds = false
        lineView.clipsToBounds = true
        lineView.layer.cornerRadius = 2
        
        // Set btnStopVideoCamera
        btnStopVideoCamera.layer.masksToBounds = false
        btnStopVideoCamera.clipsToBounds = true
        btnStopVideoCamera.layer.cornerRadius = 20
        btnStopVideoCamera.contentMode = .scaleAspectFit
        btnStopVideoCamera.layer.borderWidth = 1
        btnStopVideoCamera.layer.borderColor = UIColor.lightGray.cgColor
        btnStopVideoCamera.backgroundColor = .darkGray
        lblStopVideoCamera.text = "stop"
        
        // Set btnStartVideoCamera
        btnStartVideoCamera.layer.masksToBounds = false
        btnStartVideoCamera.clipsToBounds = true
        btnStartVideoCamera.layer.cornerRadius = 20
        btnStartVideoCamera.contentMode = .scaleAspectFit
        btnStartVideoCamera.layer.borderWidth = 1
        btnStartVideoCamera.layer.borderColor = UIColor.lightGray.cgColor
        btnStartVideoCamera.backgroundColor = .darkGray
        lblStartVideoCamera.text = "start"
        
        // Set btnFlipCamera
        btnFlipCamera.layer.masksToBounds = false
        btnFlipCamera.clipsToBounds = true
        btnFlipCamera.layer.cornerRadius = 20
        btnFlipCamera.contentMode = .scaleAspectFit
        btnFlipCamera.layer.borderWidth = 1
        btnFlipCamera.layer.borderColor = UIColor.lightGray.cgColor
        btnFlipCamera.backgroundColor = .darkGray
        lblFlipCamera.text = "flip"
        
        // Set btnEndCall
        btnEndCall.layer.masksToBounds = false
        btnEndCall.clipsToBounds = true
        btnEndCall.layer.cornerRadius = 20
        btnEndCall.contentMode = .scaleAspectFit
        btnEndCall.layer.borderWidth = 1
        btnEndCall.layer.borderColor = UIColor.lightGray.cgColor
        btnEndCall.backgroundColor = .red
        lblEndCall.text = "end"
    }
}
