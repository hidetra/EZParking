//
//  SouthGarageViewController.swift
//  EZ Parking
//
//  Created by Toan Tran, Tan Nguye, Khoa Pham, and Hieu Hoang on 11/11/19.
//  Copyright © 2019 Toan Tran. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class SouthGarageViewController: UIViewController {

    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var reserveButtonLabel1: UIButton!
    @IBOutlet weak var reserveButtonLabel2: UIButton!
    @IBOutlet weak var reserveButtonLabel3: UIButton!
    @IBOutlet weak var reserveTicket: UIButton!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUserAndConfigureView()
    }
    
    var number = 0
    var currentName = ""
    
    @IBAction func CancelReservation(_ sender: UIButton) {
        sender.pulsate()
        var temp = ""
        if(number == 4){
            temp = "south1"
        } else if (number == 5){
            temp = "south2"
        } else if (number == 6){
            temp = "south3"
        }

        var ref: DatabaseReference!
        ref = Database.database().reference()

        guard let uid = Auth.auth().currentUser?.uid else { return }
        currentName = uid
        Database.database().reference().child("users").child(currentName).child("name").observeSingleEvent(of: .value) { (snapshot) in
            guard let userlogin = snapshot.value as? String else { return }

            ref.child("reserve").child(temp).child("name").observe(.value) { (snapshot) in
                guard let user = snapshot.value as? String else { return }
                if(user == userlogin){
                    print(user + "\n")
                    print(userlogin + "\n")
                    sender.cancelReservation(number: self.number)
                    //sender.isSelected = !sender.isSelected
                    self.reserveButtonLabel2.isEnabled = true
                    self.reserveButtonLabel3.isEnabled = true
                    self.reserveButtonLabel1.isEnabled = true
                    self.CancelButton.isHidden = true
                    self.CancelButton.isEnabled = false
                }
            }
        }
    }
    
    @IBAction func homeButton(_ sender: UIButton) {
        print("home button tapped")
    }
    
    @IBAction func signOutButton(_ sender: UIButton) {
        sender.signOut()
        let signinViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.present(signinViewController, animated: true)
    }
    
    @IBAction func Reserve(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.pulsate()
        if (sender.isSelected == false) {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            Database.database().reference().child("users").child(uid).child("name").observeSingleEvent(of: .value) { (snapshot) in
                guard let user = snapshot.value as? String else { return }
                let post = [ "south1": "1", "name": user ]
                Database.database().reference().child("reserve/south1").setValue(post)
            }
            
        } else if (sender.isSelected == true) {
            reserveButtonLabel1.isSelected = true
            reserveButtonLabel2.isSelected = false
            reserveButtonLabel3.isSelected = false
            number = 4
        }
    }
    
    @IBAction func Reserve2(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.pulsate()
        if (sender.isSelected == false) {
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            Database.database().reference().child("users").child(uid).child("name").observeSingleEvent(of: .value) { (snapshot) in
                guard let user = snapshot.value as? String else { return }
                let post = ["south2": "1", "name": user]
                Database.database().reference().child("reserve/south2").setValue(post)
            }
        
        } else if (sender.isSelected == true) {
            reserveButtonLabel1.isSelected = false
            reserveButtonLabel2.isSelected = true
            reserveButtonLabel3.isSelected = false
            number = 5
        }
    }
    
    @IBAction func Reserve3(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.pulsate()
        if (sender.isSelected == false) {
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            Database.database().reference().child("users").child(uid).child("name").observeSingleEvent(of: .value) { (snapshot) in
                guard let user = snapshot.value as? String else { return }
                let post = ["south3": "1", "name": user ]
            Database.database().reference().child("reserve/south3").setValue(post)
            }
        
        } else if (sender.isSelected == true) {
            reserveButtonLabel1.isSelected = false
            reserveButtonLabel2.isSelected = false
            reserveButtonLabel3.isSelected = true
            number = 6
        }
    }
    
    func authenticateUserAndConfigureView() {
        if Auth.auth().currentUser != nil {
            loadUserData()
            loadStatus()
        } else {
            DispatchQueue.main.async {
            let navController = UINavigationController(rootViewController: SignInViewController())
            navController.navigationBar.barStyle = .black
            self.present(navController, animated: true, completion: nil)
            }
        }
    }
    
    func loadUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).child("name").observeSingleEvent(of: .value) { (snapshot) in
            guard let user = snapshot.value as? String else { return }
            self.userFullNameLabel.text = "Welcome, \(user)"
        }
    }
    
    func loadStatus() {
       var ref: DatabaseReference!
       ref = Database.database().reference()
       
       guard let uid = Auth.auth().currentUser?.uid else { return }
       
        ref.child("users").child(uid).child("name").observeSingleEvent(of: .value) { (snapshot) in
            guard let userlogin = snapshot.value as? String else { return }
        
            ref.child("reserve").child("south1").child("name").observe(.value) { (snapshot) in
                guard let user = snapshot.value as? String else { return }
            
                ref.child("reserve").child("south1").child("south1").observe(.value, with: { (snapshot) in
                    guard let parking = snapshot.value as? String else {return}
                    let freeSlot1 = (parking as NSString).intValue
                    
                    ref.child("parking").child("south1").observe(.value, with: { (snapshot) in
                    guard let parking = snapshot.value as? String else {return}
                    let freeSlot = (parking as NSString).intValue
                    
                    if (freeSlot == 1) || (freeSlot1 == 1 && freeSlot == 1) {
                        self.reserveButtonLabel1.setTitle("1\nOCCUPIED", for: .normal)
                        self.reserveButtonLabel1.setTitleColor(.white, for: .normal)
                        self.reserveButtonLabel1.titleLabel?.textAlignment = NSTextAlignment.center
                        self.reserveButtonLabel1.backgroundColor = #colorLiteral(red: 1, green: 0.5827542543, blue: 0, alpha: 1)
                        self.reserveTicket.isHidden = true
                        self.CancelButton.isHidden = true
                        
                    } else if (freeSlot1 == 1) {
                        self.reserveButtonLabel1.setTitle("RESERVED\nFOR\n\(user)", for: .normal)
                        self.reserveButtonLabel1.setTitleColor(.white, for: .normal)
                        self.reserveButtonLabel1.titleLabel?.textAlignment = NSTextAlignment.center
                        self.reserveButtonLabel1.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                        self.reserveTicket.setTitle("YOUR\nRESERVATION\n\nSOUTH 1", for: .normal)
                        self.reserveTicket.setTitleColor(.black, for: .normal)
                        self.reserveTicket.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                        self.reserveTicket.titleLabel?.textAlignment = NSTextAlignment.center
                        self.reserveButtonLabel1.isEnabled = false
                        if (user == userlogin) {
                            self.CancelButton.isHidden = false
                            self.CancelButton.isEnabled = true
                            self.reserveButtonLabel2.isEnabled = false
                            self.reserveButtonLabel3.isEnabled = false
                            self.reserveTicket.isHidden = false
                        } else {
                            self.CancelButton.isEnabled = false
                            self.CancelButton.isHidden = true
                            self.reserveTicket.isHidden = true
                            self.reserveButtonLabel2.isEnabled = true
                            self.reserveButtonLabel3.isEnabled = true
                            }
               
                    } else if (freeSlot1 == 0) {
                        ref.child("parking").child("south1").observe(.value, with: { (snapshot) in
                            guard let parking = snapshot.value as? String else {return}
                            let freeSlot = (parking as NSString).intValue
                            if (freeSlot == 0) {
                                self.reserveButtonLabel1.setTitle("1\nEMPTY", for: .normal)
                                self.reserveButtonLabel1.setTitleColor(.white, for: .normal)
                                self.reserveButtonLabel1.titleLabel?.textAlignment = NSTextAlignment.center
                                self.reserveButtonLabel1.backgroundColor = #colorLiteral(red: 0, green: 0.6234771609, blue: 0, alpha: 1)
                                self.reserveTicket.isHidden = true
                                self.reserveButtonLabel1.isEnabled = true
                                self.CancelButton.isEnabled = true
                                self.CancelButton.isHidden = true
                            }
                        })
                    }
                })
            })
        }
        
            ref.child("reserve").child("south2").child("name").observe(.value) { (snapshot) in
                guard let user = snapshot.value as? String else { return }
                    
                ref.child("reserve").child("south2").child("south2").observe(.value, with: { (snapshot) in
                    guard let parking = snapshot.value as? String else {return}
                    let freeSlot2 = (parking as NSString).intValue
                    
                    ref.child("parking").child("south2").observe(.value, with: { (snapshot) in
                    guard let parking = snapshot.value as? String else {return}
                    let freeSlot = (parking as NSString).intValue
                    
                    if (freeSlot == 1 ) || (freeSlot2 == 1 && freeSlot == 1) {
                        self.reserveButtonLabel2.setTitle("2\nOCCUPIED", for: .normal)
                        self.reserveButtonLabel2.setTitleColor(.white, for: .normal)
                        self.reserveButtonLabel2.titleLabel?.textAlignment = NSTextAlignment.center
                        self.reserveButtonLabel2.backgroundColor = #colorLiteral(red: 1, green: 0.5827542543, blue: 0, alpha: 1)
                        self.reserveTicket.setTitle("", for: .normal)
                        self.reserveTicket.setTitleColor(.black, for: .normal)
                        self.reserveTicket.titleLabel?.textAlignment = NSTextAlignment.center
                        self.reserveTicket.isHidden = true
                        self.CancelButton.isHidden = true
                        
                    } else if (freeSlot2 == 1) {
                        self.reserveButtonLabel2.setTitle("RESERVED\nFOR\n\(user)", for: .normal)
                        self.reserveButtonLabel2.setTitleColor(.white, for: .normal)
                        self.reserveButtonLabel2.titleLabel?.textAlignment = NSTextAlignment.center
                        self.reserveButtonLabel2.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                        self.reserveTicket.setTitle("YOUR\nRESERVATION\n\nSOUTH 2", for: .normal)
                        self.reserveTicket.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                        self.reserveTicket.setTitleColor(.black, for: .normal)
                        self.reserveTicket.titleLabel?.textAlignment = NSTextAlignment.center
                        if (user == userlogin) {
                            self.CancelButton.isHidden = false
                            self.CancelButton.isEnabled = true
                            self.reserveButtonLabel1.isEnabled = false
                            self.reserveButtonLabel3.isEnabled = false
                            self.reserveTicket.isHidden = false
                        } else {
                            self.CancelButton.isEnabled = false
                            self.CancelButton.isHidden = true
                            self.reserveButtonLabel1.isEnabled = true
                            self.reserveButtonLabel3.isEnabled = true
                            self.reserveTicket.isHidden = true
                        }
                
            } else if (freeSlot2 == 0) {
                ref.child("parking").child("south2").observe(.value, with: { (snapshot) in
                    guard let parking = snapshot.value as? String else {return}
                    let freeSlot = (parking as NSString).intValue
                    if (freeSlot == 0) {
                        self.reserveButtonLabel2.setTitle("2\nEMPTY", for: .normal)
                        self.reserveButtonLabel2.setTitleColor(.white, for: .normal)
                        self.reserveButtonLabel2.titleLabel?.textAlignment = NSTextAlignment.center
                        self.reserveButtonLabel2.backgroundColor = #colorLiteral(red: 0, green: 0.6234771609, blue: 0, alpha: 1)
                        self.reserveTicket.setTitle("", for: .normal)
                        self.reserveTicket.setTitleColor(.black, for: .normal)
                        self.reserveTicket.titleLabel?.textAlignment = NSTextAlignment.center
                    
                    }
                })
            }
        })
    })
}
        ref.child("reserve").child("south3").child("name").observe(.value) { (snapshot) in
        guard let user = snapshot.value as? String else { return }
            
            ref.child("reserve").child("south3").child("south3").observe(.value, with: { (snapshot) in
            guard let parking = snapshot.value as? String else {return}
            let freeSlot3 = (parking as NSString).intValue
                
                ref.child("parking").child("south3").observe(.value, with: { (snapshot) in
                guard let parking = snapshot.value as? String else {return}
                let freeSlot = (parking as NSString).intValue
                
                if (freeSlot == 1 ) || (freeSlot3 == 1 && freeSlot == 1){
                    self.reserveButtonLabel3.setTitle("3\nOCCUPIED", for: .normal)
                    self.reserveButtonLabel3.setTitleColor(.white, for: .normal)
                    self.reserveButtonLabel3.titleLabel?.textAlignment = NSTextAlignment.center
                    self.reserveButtonLabel3.backgroundColor = #colorLiteral(red: 1, green: 0.5827542543, blue: 0, alpha: 1)
                    self.reserveTicket.setTitle("", for: .normal)
                    self.reserveTicket.setTitleColor(.black, for: .normal)
                    self.reserveTicket.titleLabel?.textAlignment = NSTextAlignment.center
                    self.reserveTicket.isHidden = true
                    self.CancelButton.isHidden = true
                } else if (freeSlot3 == 1) {
                    self.reserveButtonLabel3.setTitle("\(user)\nRESERVED", for: .normal)
                    self.reserveButtonLabel3.setTitleColor(.white, for: .normal)
                    self.reserveButtonLabel3.titleLabel?.textAlignment = NSTextAlignment.center
                    self.reserveButtonLabel3.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                    self.reserveTicket.setTitle("\(user)\nYOUR RESERVATION\n\nSOUTH 3", for: .normal)
                    self.reserveTicket.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                    self.reserveTicket.setTitleColor(.black, for: .normal)
                    self.reserveTicket.titleLabel?.textAlignment = NSTextAlignment.center
                    if(user == userlogin) {
                        self.CancelButton.isHidden = false
                        self.CancelButton.isEnabled = true
                        self.reserveButtonLabel2.isEnabled = false
                        self.reserveButtonLabel1.isEnabled = false
                        self.reserveTicket.isHidden = false
                    } else {
                        self.CancelButton.isEnabled = false
                        self.CancelButton.isHidden = true
                        self.reserveButtonLabel2.isEnabled = true
                        self.reserveButtonLabel1.isEnabled = true
                        self.reserveTicket.isHidden = true
                        }
            } else if (freeSlot3 == 0) {
                ref.child("parking").child("south3").observe(.value, with: { (snapshot) in
                    guard let parking = snapshot.value as? String else {return}
                    let freeSlot = (parking as NSString).intValue
                    if (freeSlot == 0) {
                        self.reserveButtonLabel3.setTitle("3\nEMPTY", for: .normal)
                        self.reserveButtonLabel3.setTitleColor(.white, for: .normal)
                        self.reserveButtonLabel3.titleLabel?.textAlignment = NSTextAlignment.center
                        self.reserveButtonLabel3.backgroundColor = #colorLiteral(red: 0, green: 0.6234771609, blue: 0, alpha: 1)
                        self.reserveTicket.setTitle("", for: .normal)
                        self.reserveTicket.setTitleColor(.black, for: .normal)
                        self.reserveTicket.titleLabel?.textAlignment = NSTextAlignment.center
                                }
                            })
                        }
                    })
                })
            }
        }
    }
}
