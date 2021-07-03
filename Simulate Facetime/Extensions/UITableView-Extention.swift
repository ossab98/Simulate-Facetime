//
//  UITableView-Extention.swift
//  Simulate Facetime
//
//  Created by Ossama Abdelwahab on 02/07/21.
//

import UIKit

extension UITableView{
    func updateEmptyState(rowsCount: Int, emptyMessage: String){
        if rowsCount == 0 {
            showEmptyState(emptyMessage)
        }else{
            hideEmptyState()
        }
    }
    
    private func showEmptyState(_ message: String){
        let label = UILabel(frame: .zero)
        label.text = message
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 0
        
        // turn off autoresizing masks (storyboards do this automatically)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let containerView = UIView(frame: self.frame)
        containerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -100)
        ])
        
        backgroundView = containerView
    }
    
    private func hideEmptyState(){
        backgroundView = nil
    }
    
}
