//
//  ContactsCell.swift
//  Simulate Facetime
//
//  Created by Ossama Abdelwahab on 02/07/21.
//

import UIKit

class ContactsCell: UITableViewCell {
    
    // MARK:- Outlets
    @IBOutlet private weak var imgUserProfile: UIImageView!
    @IBOutlet private weak var lblUserFullName: UILabel!
    @IBOutlet private weak var lblUserLastCall: UILabel!
    
    func setUpCell(_ user: User){
        
        // Set user profile
        imgUserProfile.layer.masksToBounds = false
        imgUserProfile.clipsToBounds = true
        imgUserProfile.layer.cornerRadius = imgUserProfile.frame.height/2
        imgUserProfile.contentMode = .scaleAspectFit
        imgUserProfile.layer.borderWidth = 2
        imgUserProfile.layer.borderColor = UIColor.darkGray.cgColor
        imgUserProfile.backgroundColor = .white
        imgUserProfile.image = #imageLiteral(resourceName: "avatar-placeholder")
        
        // Set user fullname
        lblUserFullName.text = user.name
        lblUserFullName.numberOfLines = 1
        
        // Set last call
        lblUserLastCall.text = "Last call in \(user.lastCallDate) - at: \(user.lastCallTime)'"
        lblUserLastCall.numberOfLines = 1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
