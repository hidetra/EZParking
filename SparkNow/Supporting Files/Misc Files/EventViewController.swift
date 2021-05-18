//
//  EventViewController.swift
//  EZ Parking
//
//  Created by Toan Tran, Tan Nguye, Khoa Pham, and Hieu Hoang on 11/11/19.
//  Copyright © 2019 Toan Tran. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import WebKit

class EventViewController: UIViewController {

    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUserAndConfigureView()
        // Do any additional setup after loading the view.
        
        let myURL = URL(string:"http://www.sjsu.edu/parking")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    

    @IBAction func homeButton(_ sender: Any) {
        print("home button tapped")
    }
    
    @IBAction func signOutButton(_ sender: UIButton) {
        sender.signOut()
        
        let signinViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        
        self.present(signinViewController, animated: true)
    }
    
    func authenticateUserAndConfigureView() {
        if Auth.auth().currentUser != nil {
            loadUserData()
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


}
