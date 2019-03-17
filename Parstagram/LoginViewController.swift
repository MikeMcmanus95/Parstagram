//
//  LoginViewController.swift
//  Parstagram
//
//  Created by Michael Mcmanus on 3/16/19.
//  Copyright © 2019 Michael Mcmanus. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func onSignIn(_ sender: Any) {
        let username = usernameField.text!
        let password = passwordField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
            else {
                let alert = UIAlertController(title: "Error", message: "Invalid username/password combination. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
                
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    
    @IBAction func onSignUp(_ sender: Any) {
        let user = PFUser()
        user.username = usernameField.text
        user.password = passwordField.text
      //  user.email = "email@example.com" OPTIONAL
        // other fields can be set just like with PFObject
      //  user["phone"] = "415-392-0202"
        
        user.signUpInBackground { (success, error) in
            
            if success {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
            else {
                let alert = UIAlertController(title: "Error", message: "Something went wrong, unable to create account. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
                
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
