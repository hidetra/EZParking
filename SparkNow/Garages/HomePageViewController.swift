//
//  HomePageViewController.swift
//  EZ Parking
//
//  Created by Toan Tran, Tan Nguye, Khoa Pham, and Hieu Hoang on 11/11/19.
//  Copyright © 2019 Toan Tran. All rights reserved.
//
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class HomePageViewController: UIViewController {

    @IBOutlet weak var southLabel: UILabel!
    @IBOutlet weak var northLabel: UILabel!
    @IBOutlet weak var westLabel: UILabel!
    @IBOutlet weak var parknrideLabel: UILabel!
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet var menuButton: [UIButton]!

    @IBAction func selectionHandler(_ sender: UIButton) {
        menuButton.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
            })
        }
    }
    
    // UI Buttons
    @IBAction func westGarageView(_ sender: Any) {
        print("west garage button tapped")
    }
    
    @IBAction func northGarageView(_ sender: Any) {
        print("north garage button tapped")
    }
    
    @IBAction func southGarageView(_ sender: Any) {
        print("south garage button tapped")
    }
    @IBAction func parkNRideView(_ sender: Any) {
        print("park and ride garage button tapped")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUserAndConfigureView()
    }
    
    @IBAction func signOutButtonTapped(_ sender: UIButton) {
        sender.signOut()
        let signinViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        
        self.present(signinViewController, animated: true)
        
    }
    
    //Authenticate user info
    func authenticateUserAndConfigureView() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let navController = UINavigationController(rootViewController: SignInViewController())
                navController.navigationBar.barStyle = .black
                self.present(navController, animated: true, completion: nil)
            }
        } else {
            
            loadParkStatus()
            loadUserData()
        }
    }
    
    func loadUserData() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(userID).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = snapshot.value as? String else { return }
            self.userFullNameLabel.text = "Welcome \(user)"
        })
    }
    
    
    func loadParkStatus() {
    
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("reserve").child("north1").child("north1").observe(.value, with: { (snapshot) in
        guard let reserve1 = snapshot.value as? String else {return}
            let reserveSlot1 = (reserve1 as NSString).intValue
            
            ref.child("reserve").child("north2").child("north2").observe(.value, with: { (snapshot) in
        guard let reserve2 = snapshot.value as? String else {return}
            let reserveSlot2 = (reserve2 as NSString).intValue
            
            ref.child("reserve").child("north3").child("north3").observe(.value, with: { (snapshot) in
        guard let reserve3 = snapshot.value as? String else {return}
            let reserveSlot3 = (reserve3 as NSString).intValue
            
        ref.child("parking").child("North").observe(.value, with: { (snapshot) in
        guard let parking = snapshot.value as? String else {return}
        let freeParking = (parking as NSString).intValue
            
            let reserveSlot = (reserveSlot1 + reserveSlot2 + reserveSlot3)
            
            let freeSlot = (freeParking - reserveSlot)
            
            if (freeSlot == 3)||(freeSlot == 2) {
                self.northLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.northLabel.backgroundColor = #colorLiteral(red: 0, green: 0.6234771609, blue: 0, alpha: 1)
                self.northLabel.text = "\(freeSlot)\n" + " Available"
            } else if (freeSlot == 1) {
                self.northLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                self.northLabel.backgroundColor = #colorLiteral(red: 1, green: 0.5827542543, blue: 0, alpha: 1)
                self.northLabel.text = "\(freeSlot)\n" + " Available"
            } else if (freeSlot == 0){
                self.northLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                self.northLabel.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                self.northLabel.text = "PARKING IS FULL"
            } else {
                self.northLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                self.northLabel.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
                self.northLabel.text = "LOADING..."
            }
        })})})})
        
        ref.child("reserve").child("south1").child("south1").observe(.value, with: { (snapshot) in
        guard let reserveSouth1 = snapshot.value as? String else {return}
        let reserveFreeSlotSouth1 = (reserveSouth1 as NSString).intValue
                
        ref.child("reserve").child("south2").child("south2").observe(.value, with: { (snapshot) in
        guard let reserveSouth2 = snapshot.value as? String else {return}
        let reserveFreeSlotSouth2 = (reserveSouth2 as NSString).intValue
                
        ref.child("reserve").child("south3").child("south3").observe(.value, with: { (snapshot) in
        guard let reserveSouth3 = snapshot.value as? String else {return}
        let reserveFreeSlotSouth3 = (reserveSouth3 as NSString).intValue
                
        ref.child("parking").child("South").observe(.value, with: { (snapshot) in
            guard let parking = snapshot.value as? String else {return}
            let freeSlotParking = (parking as NSString).intValue
            
            let reserveFreeSlot = (reserveFreeSlotSouth1 + reserveFreeSlotSouth2 + reserveFreeSlotSouth3)
            
            let freeSlot = (freeSlotParking - reserveFreeSlot)
            
            if (freeSlot == 3) || (freeSlot == 2) {
                self.southLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.southLabel.backgroundColor = #colorLiteral(red: 0, green: 0.6234771609, blue: 0, alpha: 1)
                self.southLabel.text = "\(freeSlot)\nAvailable"
            } else if (freeSlot == 1 ) {
                self.southLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                self.southLabel.backgroundColor = #colorLiteral(red: 1, green: 0.5827542543, blue: 0, alpha: 1)
                self.southLabel.text = "\(freeSlot)\nAvailable"
            } else if (freeSlot == 0){
                self.northLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                self.northLabel.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                self.northLabel.text = "PARKING IS FULL"
            } else {
                self.northLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                self.northLabel.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
                self.northLabel.text = "LOADING..."
            }
        })})})})
        
        self.westLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.westLabel.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        self.westLabel.text = "PARKING IS FULL"
        
        self.parknrideLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.parknrideLabel.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        self.parknrideLabel.text = "PARKING IS FULL"
        

    }
    

}
