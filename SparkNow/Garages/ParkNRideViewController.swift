//
//  ParkNRideViewController.swift
//  EZ Parking
//
//  Created by Toan Tran, Tan Nguye, Khoa Pham, and Hieu Hoang on 11/11/19.
//  Copyright © 2019 Toan Tran. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import GoogleMaps

class ParkNRideViewController: UIViewController {

    @IBOutlet weak var userFullNameLabel: UILabel!
    
    @IBOutlet weak var labelStatus: UILabel!
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
    
    func authenticateUserAndConfigureView() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let navController = UINavigationController(rootViewController: SignInViewController())
                navController.navigationBar.barStyle = .black
                self.present(navController, animated: true, completion: nil)
            }
        } else {
            loadUserData()
            loadStatus()
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
            Database.database().reference().child("parking").child("parknride").observe(.value, with: { (snapshot) in
                guard let parking = snapshot.value as? String else {return}
                let percent = (parking as NSString).doubleValue
                if (percent < 50.0) {
                    self.labelStatus.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    self.labelStatus.backgroundColor = #colorLiteral(red: 0, green: 0.6234771609, blue: 0, alpha: 1)
                    self.labelStatus.text = "\(percent)" + "%"
                } else if (percent <= 90.0) {
                    self.labelStatus.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    self.labelStatus.backgroundColor = #colorLiteral(red: 1, green: 0.5827542543, blue: 0, alpha: 1)
                    self.labelStatus.text = "\(percent)" + "%"
                } else {
                    self.labelStatus.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    self.labelStatus.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
                    self.labelStatus.text = "\(percent)" + "%"
                }
            })
        }

    }
