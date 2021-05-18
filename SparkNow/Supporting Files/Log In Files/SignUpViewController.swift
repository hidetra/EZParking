//
//  SignUpViewController.swiftRegisterUserViewController
//  EZ Parking
//
//  Created by Toan Tran, Tan Nguye, Khoa Pham, and Hieu Hoang on 11/11/19.
//  Copyright © 2019 Toan Tran. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        print("cancel button tapped")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        print("sign up button tapped")
        
        
       if(firstNameTextField.text?.isEmpty)! || (lastNameTextField.text?.isEmpty)! || (usernameTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            
            //Display alert message
            displayMessage(userMessage: "All fields are required")
            return
        }
        
        //Validate password
        if ((passwordTextField.text?.elementsEqual(repeatPasswordTextField.text!))! != true)
            {
            
            //Display alert message
            displayMessage(userMessage: "Passwords must match")
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
        
        if let email = usernameTextField.text, let password = passwordTextField.text, let name = firstNameTextField.text {
            Auth.auth().createUser(withEmail: email, password: password, completion: { user, error in
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    return
                }
                
                guard let uid = user?.user.uid else { return }
                
                let values = ["email": email, "name": name]
                
                Database.database().reference().child("users").child(uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
                    if let error = error {
                        print("Failed to update database values with error: ", error.localizedDescription)
                        return
                    }
                print("Registration Successful!")
                
            })
        })
        }
        
            
        //take user back to sign in page
        let signinViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        
        self.present(signinViewController, animated: true)
     
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
    
    //remove alert indicator
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView){
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
   
}
