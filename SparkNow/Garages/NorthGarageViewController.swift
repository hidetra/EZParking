//
//  NorthGarageViewController.swift
//  EZ Parking
//
//  Created by Toan Tran, Tan Nguye, Khoa Pham, and Hieu Hoang on 11/11/19.
//  Copyright © 2019 Toan Tran. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class NorthGarageViewController: UIViewController {

    @IBOutlet weak var reserveLabel1: UIButton!
    @IBOutlet weak var reserveLabel2: UIButton!
    @IBOutlet weak var reserveLabel3: UIButton!
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var reserveTicket: UIButton!
    @IBOutlet weak var CancelButton: UIButton!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUserAndConfigureView()
    }
    
    @IBAction func signOutButton(_ sender: UIButton) {
        sender.signOut()
        let signinViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        
        self.present(signinViewController, animated: true)
    }
    

    var number = 0
    var currentName = ""
    
    @IBAction func CancelReserve(_ sender: UIButton) {
        sender.pulsate()
        var temp = ""
        if(number == 1){
            temp = "north1"
        } else if (number == 2){
            temp = "north2"
        } else if (number == 3){
            temp = "north3"
        }

        var ref: DatabaseReference!
        ref = Database.database().reference()

        guard let uid = Auth.auth().currentUser?.uid else { return }
        currentName = uid
        ref.child("users").child(currentName).child("name").observeSingleEvent(of: .value) { (snapshot) in
            guard let userlogin = snapshot.value as? String else { return }

            ref.child("reserve").child(temp).child("name").observe(.value) { (snapshot) in
                guard let user = snapshot.value as? String else { return }
                
                //there is something wrong with this algorithm that is affecting the reservation button on the second time.
                if(user == userlogin){
                    print(user + "\n")
                    print(userlogin + "\n")
                    sender.cancelReservation(number: self.number)
                }
            }
        }
        self.resetButton()
    }
    

    @IBAction func Reserve(_ sender: UIButton) {
        print("north1 button tapped")
        sender.isSelected = !sender.isSelected
        sender.pulsate()
        if (sender.isSelected == false) {
            number = 1
            var ref:DatabaseReference!
            ref = Database.database().reference()
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            ref.child("users").child(uid).child("name").observeSingleEvent(of: .value) { (snapshot) in
            guard let user = snapshot.value as? String else { return }
            let post = [ "north1": "1", "name": user ]
                ref.child("reserve/north1").setValue(post)
            
            }
        } else if (sender.isSelected == true) {
           //let post = [ "north1": "0", "name": "" ]
            //Database.database().reference().child("reserve/north1").setValue(post)
            reserveLabel1.isSelected = true
            reserveLabel2.isSelected = false
            reserveLabel3.isSelected = false
            }
        }
    
    @IBAction func Reserve2(_ sender: UIButton) {
        print("north2 button tapped")
        sender.isSelected = !sender.isSelected
        sender.pulsate()
        if (sender.isSelected == false) {
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            Database.database().reference().child("users").child(uid).child("name").observeSingleEvent(of: .value) { (snapshot) in
                guard let user = snapshot.value as? String else { return }
                let post = ["north2": "1", "name": user]
                Database.database().reference().child("reserve/north2").setValue(post)
            }
            
        } else if (sender.isSelected == true) {
            reserveLabel1.isSelected = false
            reserveLabel2.isSelected = true
            reserveLabel3.isSelected = false
            number = 2
        }
    }
    
    @IBAction func Reserve3(_ sender: UIButton) {
        print("north3 button tapped")
        sender.isSelected = !sender.isSelected
        sender.pulsate()
        if (sender.isSelected == false) {
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            Database.database().reference().child("users").child(uid).child("name").observeSingleEvent(of: .value) { (snapshot) in
                guard let user = snapshot.value as? String else { return }
                let post = ["north3": "1", "name": user]
                Database.database().reference().child("reserve/north3").setValue(post)
            }
            
        } else if (sender.isSelected == true) {
            reserveLabel1.isSelected = false
            reserveLabel2.isSelected = false
            reserveLabel3.isSelected = true
            number = 3
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
    func resetButton() {
        self.reserveLabel2.isEnabled = true
        self.reserveLabel3.isEnabled = true
        self.reserveLabel1.isEnabled = true
        self.reserveLabel1.isSelected = false
        self.reserveLabel2.isSelected = false
        self.reserveLabel3.isSelected = false
        self.CancelButton.isHidden = true
        self.CancelButton.isEnabled = false
    }
    func occupiedReserve1(){
        self.reserveLabel1.setTitle("1\nOCCUPIED", for: .normal)
        self.reserveLabel1.setTitleColor(.white, for: .normal)
        self.reserveLabel1.titleLabel?.textAlignment = NSTextAlignment.center
        self.reserveLabel1.backgroundColor = #colorLiteral(red: 1, green: 0.5827542543, blue: 0, alpha: 1)
        self.reserveTicket.isHidden = true
        self.CancelButton.isHidden = true
    }
    func loadStatus() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
    
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ref.child("users").child(uid).child("name").observeSingleEvent(of: .value) { (snapshot) in
            guard let userlogin = snapshot.value as? String else { return }
            
            ref.child("reserve").child("north1").child("name").observe(.value) { (snapshot) in
                guard let user = snapshot.value as? String else { return }
           
                ref.child("reserve").child("north1").child("north1").observe(.value, with: { (snapshot) in
                    guard let parking = snapshot.value as? String else {return}
                    let freeSlot1 = (parking as NSString).intValue
            
                ref.child("parking").child("north1").observe(.value, with: { (snapshot) in
                    guard let parking = snapshot.value as? String else {return}
                    let freeSlot = (parking as NSString).intValue
            
            if (freeSlot == 1) || (freeSlot1 == 1 && freeSlot == 1) {
                self.occupiedReserve1()
                }
            else if (freeSlot1 == 1){
                self.reserveLabel1.setTitle("RESERVED\nFOR\n\(user)", for: .normal)
                self.reserveLabel1.setTitleColor(.white, for: .normal)
                self.reserveLabel1.titleLabel?.textAlignment = NSTextAlignment.center
                self.reserveLabel1.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                self.reserveTicket.setTitle("YOUR\nRESERVATION\n\nNORTH 1", for: .normal)
                self.reserveTicket.setTitleColor(.black, for: .normal)
                self.reserveTicket.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                self.reserveTicket.titleLabel?.textAlignment = NSTextAlignment.center
                self.reserveLabel1.isEnabled = false
                if(user == userlogin) {
                    self.CancelButton.isHidden = false
                    self.CancelButton.isEnabled = true
                    self.reserveLabel2.isEnabled = false
                    self.reserveLabel3.isEnabled = false
                    self.reserveTicket.isHidden = false
                } else {
                    self.CancelButton.isEnabled = false
                    self.CancelButton.isHidden = true
                    self.reserveTicket.isHidden = true
                    self.reserveLabel2.isEnabled = true
                    self.reserveLabel3.isEnabled = true
                    }
                    
            } else if (freeSlot1 == 0) {
                ref.child("parking").child("north1").observe(.value, with: { (snapshot) in
                    guard let parking = snapshot.value as? String else {return}
                    let freeSlot = (parking as NSString).intValue
                    if (freeSlot == 0) {
                        self.reserveLabel1.setTitle("1\nEMPTY", for: .normal)
                        self.reserveLabel1.setTitleColor(.white, for: .normal)
                        self.reserveLabel1.titleLabel?.textAlignment = NSTextAlignment.center
                        self.reserveLabel1.backgroundColor = #colorLiteral(red: 0, green: 0.6234771609, blue: 0, alpha: 1)
                        self.reserveTicket.isHidden = true
                        self.reserveLabel1.isEnabled = true
                        self.CancelButton.isEnabled = false
                        self.CancelButton.isHidden = true
                        }
                    })
                }
            })
        })
    }
        
        ref.child("reserve").child("north2").child("name").observe(.value) { (snapshot) in
        guard let user = snapshot.value as? String else { return }
            
        ref.child("reserve").child("north2").child("north2").observe(.value, with: { (snapshot) in
            guard let parking = snapshot.value as? String else {return}
            let freeSlot2 = (parking as NSString).intValue
            
            ref.child("parking").child("north2").observe(.value, with: { (snapshot) in
            guard let parking = snapshot.value as? String else {return}
            let freeSlot = (parking as NSString).intValue
            
            if (freeSlot == 1 ) || (freeSlot2 == 1 && freeSlot == 1){
                self.reserveLabel2.setTitle("2\nOCCUPIED", for: .normal)
                self.reserveLabel2.setTitleColor(.white, for: .normal)
                self.reserveLabel2.titleLabel?.textAlignment = NSTextAlignment.center
                self.reserveLabel2.backgroundColor = #colorLiteral(red: 1, green: 0.5827542543, blue: 0, alpha: 1)
                self.reserveTicket.setTitle("", for: .normal)
                self.reserveTicket.setTitleColor(.black, for: .normal)
                self.reserveTicket.titleLabel?.textAlignment = NSTextAlignment.center
                self.reserveTicket.isHidden = true
                self.CancelButton.isHidden = true
            
            } else if (freeSlot2 == 1) {
                self.reserveLabel2.setTitle("RESERVED\nFOR\n\(user)", for: .normal)
                self.reserveLabel2.setTitleColor(.white, for: .normal)
                self.reserveLabel2.titleLabel?.textAlignment = NSTextAlignment.center
                self.reserveLabel2.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                self.reserveTicket.setTitle("YOUR\nRESERVATION\nNORTH 2", for: .normal)
                self.reserveTicket.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                self.reserveTicket.setTitleColor(.black, for: .normal)
                self.reserveTicket.titleLabel?.textAlignment = NSTextAlignment.center
                if(user == userlogin){
                    self.CancelButton.isHidden = false
                    self.CancelButton.isEnabled = true
                    self.reserveLabel1.isEnabled = false
                    self.reserveLabel3.isEnabled = false
                    self.reserveTicket.isHidden = false
                } else {
                    self.CancelButton.isEnabled = false
                    self.CancelButton.isHidden = true
                    self.reserveLabel1.isEnabled = true
                    self.reserveLabel3.isEnabled = true
                    self.reserveTicket.isHidden = true
                }
                    
            } else if (freeSlot2 == 0) {
                ref.child("parking").child("north2").observe(.value, with: { (snapshot) in
                    guard let parking = snapshot.value as? String else {return}
                    let freeSlot = (parking as NSString).intValue
                    if (freeSlot == 0) {
                        self.reserveLabel2.setTitle("2\nEMPTY", for: .normal)
                        self.reserveLabel2.setTitleColor(.white, for: .normal)
                        self.reserveLabel2.titleLabel?.textAlignment = NSTextAlignment.center
                        self.reserveLabel2.backgroundColor = #colorLiteral(red: 0, green: 0.6234771609, blue: 0, alpha: 1)
                        self.reserveTicket.setTitle("", for: .normal)
                        self.reserveTicket.setTitleColor(.black, for: .normal)
                        self.reserveTicket.titleLabel?.textAlignment = NSTextAlignment.center
                        
                    }
                })
            }
        })
    })
}
    
        ref.child("reserve").child("north3").child("name").observe(.value) { (snapshot) in
        guard let user = snapshot.value as? String else { return }
            
            ref.child("reserve").child("north3").child("north3").observe(.value, with: { (snapshot) in
                guard let parking = snapshot.value as? String else {return}
                let freeSlot3 = (parking as NSString).intValue
                
                ref.child("parking").child("north3").observe(.value, with: { (snapshot) in
                guard let parking = snapshot.value as? String else {return}
                let freeSlot = (parking as NSString).intValue
                
                if (freeSlot == 1) || (freeSlot3 == 1 && freeSlot == 1) {
                    self.reserveLabel3.setTitle("3\nOCCUPIED", for: .normal)
                    self.reserveLabel3.setTitleColor(.white, for: .normal)
                    self.reserveLabel3.titleLabel?.textAlignment = NSTextAlignment.center
                    self.reserveLabel3.backgroundColor = #colorLiteral(red: 1, green: 0.5827542543, blue: 0, alpha: 1)
                    self.reserveTicket.setTitle("", for: .normal)
                    self.reserveTicket.setTitleColor(.black, for: .normal)
                    self.reserveTicket.titleLabel?.textAlignment = NSTextAlignment.center
                    self.reserveTicket.isHidden = true
                    self.CancelButton.isHidden = true
                
                } else if (freeSlot3 == 1) {
                    self.reserveLabel3.setTitle("RESERVED\nFOR\n\(user)", for: .normal)
                    self.reserveLabel3.setTitleColor(.white, for: .normal)
                    self.reserveLabel3.titleLabel?.textAlignment = NSTextAlignment.center
                    self.reserveLabel3.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                    self.reserveTicket.setTitle("\(user)\nYOUR RESERVATION\n\nNORTH 3", for: .normal)
                    self.reserveTicket.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                    self.reserveTicket.setTitleColor(.black, for: .normal)
                    self.reserveTicket.titleLabel?.textAlignment = NSTextAlignment.center
                        if (user == userlogin) {
                            self.CancelButton.isHidden = false
                            self.CancelButton.isEnabled = true
                            self.reserveLabel2.isEnabled = false
                            self.reserveLabel1.isEnabled = false
                            self.reserveTicket.isHidden = false
                        }
                        else {
                            self.CancelButton.isEnabled = false
                            self.CancelButton.isHidden = true
                            self.reserveLabel2.isEnabled = true
                            self.reserveLabel1.isEnabled = true
                            self.reserveTicket.isHidden = true
                        }
                    
                    }  else if (freeSlot3 == 0) {
                        ref.child("parking").child("north3").observe(.value, with: { (snapshot) in
                        guard let parking = snapshot.value as? String else {return}
                        let freeSlot = (parking as NSString).intValue
                        if (freeSlot == 0) {
                            self.reserveLabel3.setTitle("3\nEMPTY", for: .normal)
                            self.reserveLabel3.setTitleColor(.white, for: .normal)
                            self.reserveLabel3.titleLabel?.textAlignment = NSTextAlignment.center
                            self.reserveLabel3.backgroundColor = #colorLiteral(red: 0, green: 0.6234771609, blue: 0, alpha: 1)
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

