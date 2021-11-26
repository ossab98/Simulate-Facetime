//
//  UIButton-Extention.swift
//  Simulate Facetime
//
//  Created by Ossama Abdelwahab on 05/07/21.
//

import UIKit

func animateButtonClickA(buttonToAnimate: UIButton, _ duration: Double = 0.2, _ preserveIdentity: Bool = true, _ closure: @escaping () -> () = {}){
    
    UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / 500.0
        transform =  CATransform3DScale(transform, 0.8, 0.8, 1)
        buttonToAnimate.layer.transform = transform
    }, completion: { finish in
        UIView.animate(withDuration: duration, animations: {
            if preserveIdentity {
                buttonToAnimate.transform = CGAffineTransform.identity
            }
            closure()
        })
    })
}
