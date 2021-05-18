//
//  SignInViewController.swift
//  EZ Parking
//
//  Created by Toan Tran, Tan Nguye, Khoa Pham, and Hieu Hoang on 11/11/19.
//  Copyright © 2019 Toan Tran. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class SignInViewController: UIViewController {


    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
 
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        print("sign in button tapped")
        
        let userName = userNameTextField.text
        let userPassword = userPasswordTextField.text
        
        //check if required field are not empty.
        if (userName?.isEmpty)! || (userPassword?.isEmpty)! {
            //display alert message
            print("User name \(String(describing: userName)) or password \(String(describing: userPassword)) is empty")
            displayMessage(userMessage: "Required fields is missing")
            return
        }
        
        //create activity indicator
        let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        
        //Position activity indicator in the center of the main view
        myActivityIndicator.center = view.center
        
        //If needed, you can prevent activity indicator from hiding when stopAnimating() is called
        myActivityIndicator.hidesWhenStopped = false
        
        //start activity indicator
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        
        if let email = userNameTextField.text, let password = userPasswordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: {user, error in
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    self.displayMessage(userMessage: "Incorrect Username or Password")
                    return
                }
                print("Login Successful!")
                
                //if log in successful take to main home view
                let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
                
                self.present(homeViewController, animated: true)
            })
        }
    }

    @IBAction func registerNewAccountButtonTapped(_ sender: Any) {
        print("register new account button tapped")
        
        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        
        self.present(registerViewController, animated: true)
    }
    
    func displayMessage(userMessage: String) -> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "", message: userMessage, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) {
                (action:UIAlertAction!) in
                print("okay button tapped")
            }
            
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView){
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    
}

