//
//  ContactsController.swift
//  Simulate Facetime
//
//  Created by Ossama Abdelwahab on 02/07/21.
//

import UIKit

class ContactsController: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    private let blurEffect: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()
    
    // MARK: - Properties / Models
    var contacts: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // You can comment this function 'addDemoContacts' to see the app how is working without data!
        demoContacts()
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
        // present To CallingController
        let callingController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "callingController") as! CallingController
        callingController.user = contacts[indexPath.row]
        present(callingController, animated: true, completion: .none)
    }
    
    // heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK:- Func Helper
extension ContactsController{
    
    // Reload the tableView
    func reloadView(){
        DispatchQueue.main.async {
            self.tableView.updateEmptyState(rowsCount: self.contacts.count, emptyMessage: "You can initiate FaceTime Video or audio calls by entering a name, email address, or phone number.")
            self.tableView.reloadData()
        }
    }
    
    func demoContacts(){
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
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        setUpCamera()
        
        view.addSubview(blurEffect)
        view.addSubview(tableView)
        
        reloadView()
    }
    
    func setUpCamera(){
        if CameraManager.shared.isCameraSupported {
            view.layer.addSublayer(CameraManager.shared.previewLayer)
        }
    }
    
}
