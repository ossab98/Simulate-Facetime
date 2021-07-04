//
//  ContactsController.swift
//  Simulate Facetime
//
//  Created by Ossama Abdelwahab on 02/07/21.
//

import UIKit
import AVFoundation

class ContactsController: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    
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
    var contacts: [User] = []
    var deviceHasCamera = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // You can comment this function 'addDemoContacts' to see the app how is working without data!
        addDemoContacts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        CameraManager.shared.previewLayer.frame = view.bounds
        blurEffect.frame = view.bounds
    }
}

//MARK:- extension UITableViewDelegate && UITableViewDataSource
extension ContactsController: UITableViewDelegate, UITableViewDataSource {
    
    // numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactsCell", for: indexPath) as! ContactsCell
        cell.setUpCell(contacts[indexPath.row])
        return cell
    }
    
    // didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        // Push To CallingController
        let callingController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "callingController") as! CallingController
        callingController.user = contacts[indexPath.row]
        self.present(callingController, animated: true, completion: .none)
    }
    
    // heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - Func Helper
extension ContactsController {
    
    // Reload the tableView
    func reloadView(){
        DispatchQueue.main.async {
            let message = """
            Puoi iniziare chiamate FaceTime Video o audio inserendo un nome, un indirizzo e-mail o un numero telefonico.
            
            Se non funziona il video devi verificare i permessi nell'imposizione.
            
            Vai su Impostazioni > Privacy > fotocamera e attiva Accesso alla fotocamera per questa app.
            """
            self.tableView.updateEmptyState(rowsCount: self.contacts.count, emptyMessage: message)
            self.tableView.reloadData()
        }
    }
}

// MARK:- Func Helper
extension ContactsController{
    
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
        case .restricted:
            showErrorMessage(message: "\nUnable to access the Camera\nTo enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.\n")
        default:
            break
        }
    }
    
    func addDemoContacts(){
        contacts.append(User(id: 1, name: "Otacílio da Mota", lastCallDate: "02/07/2021", lastCallTime: "12:00"))
        contacts.append(User(id: 2, name: "Eliott Aubert", lastCallDate: "01/07/2021", lastCallTime: "14:34"))
        contacts.append(User(id: 3, name: "Sophia Ouellet", lastCallDate: "22/06/2021", lastCallTime: "02:12"))
        contacts.append(User(id: 4, name: "Daniel Lakso", lastCallDate: "18/06/2021", lastCallTime: "22:09"))
        contacts.append(User(id: 5, name: "Malik Margaret", lastCallDate: "15/06/2021", lastCallTime: "10:04"))
        contacts.append(User(id: 6, name: "Safiya Ritsema", lastCallDate: "01/06/2021", lastCallTime: "07:57"))
        contacts.append(User(id: 7, name: "Chester James", lastCallDate: "28/05/2021", lastCallTime: "00:21"))
        contacts.append(User(id: 8, name: "Inácia Pires", lastCallDate: "07/04/2021", lastCallTime: "21:49"))
    }
}

// MARK:- SetUpView
extension ContactsController{
    
    func setUpView(){
        
        // Set backgroundColor View
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "avatar-placeholder"))
        
        // Set TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        // add a bottom margin to tableview
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        // Check if the device has a camera to enable the videoCamera
        if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
            print("Has camera")
            DispatchQueue.main.async {
                // Check Camera Prmissions & Add Video Input in Sublayer
                CameraManager.shared.checkCameraPrmissions(position: .front)
            }
            self.view.layer.addSublayer(CameraManager.shared.previewLayer)
            deviceHasCamera = true
        }else{
            print("Hasn't camera!")
            // Remove Video Input from Sublayer
            DispatchQueue.main.async {
                CameraManager.shared.previewLayer.removeFromSuperlayer()
            }
            self.showErrorMessage(message: "\nThe camera preview is not available on this device!\n")
            deviceHasCamera = false
        }
        
        view.addSubview(blurEffect)
        authorizationStatus()
        view.addSubview(tableView)
        view.addSubview(lblErrorMessage)
        NSLayoutConstraint.activate([
            lblErrorMessage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            lblErrorMessage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            lblErrorMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            lblErrorMessage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
        reloadView()
    }
}
