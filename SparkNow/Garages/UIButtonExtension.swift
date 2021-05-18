//
//  UIButtonExtension.swift
//  EZ Parking
//
//  Created by Toan Tran, Tan Nguye, Khoa Pham, and Hieu Hoang on 11/11/19.
//  Copyright © 2019 Toan Tran. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth

extension UIButton {
    
    func pulsate() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.98
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 1.5
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: nil)
    }
    

    
    func cancelReservation(number: Int) {
        print("cancel button is tapped")
        var ref: DatabaseReference!
        ref = Database.database().reference()
        if(number == 1){
            ref.child("reserve/north1/north1").setValue("0")
            ref.child("reserve/north1/name").setValue("")
        }else if(number == 2 ){
            ref.child("reserve/north2/north2").setValue("0")
            ref.child("reserve/north2/name").setValue("")
        }else if(number == 3){
            ref.child("reserve/north3/north3").setValue("0")
            ref.child("reserve/north3/name").setValue("")
        }else if(number == 4){
            ref.child("reserve/south1/south1").setValue("0")
            ref.child("reserve/south1/name").setValue("")
        }else if(number == 5){
            ref.child("reserve/south2/south2").setValue("0")
            ref.child("reserve/south2/name").setValue("")
        }else if(number == 6){
            ref.child("reserve/south3/south3").setValue("0")
            ref.child("reserve/south3/name").setValue("")
        }
        
    }
    
    func signOut() {
        print("sign out button tapped")
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
}




