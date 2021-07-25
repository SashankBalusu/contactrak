//
//  LoginViewController.swift
//  ContacTrak
//
//  Created by Krish Iyengar, Sashank Balusu, Pranit Agrawal on 7/23/21.
//

import UIKit

// All sign up properties
var usernameSignUp = ""
var schoolNameSignUp = ""
var firstNameSignUp = ""
var lastNameSignUp = ""
var schoolIDNumberSignUp = ""
var emailSignUp = ""

// This will be the view controller for logging into the app
class LoginViewController: UIViewController {

    // All View Controller Outlets
    @IBOutlet weak var logInButtonOutlet: UIButton!
    @IBOutlet weak var signUpButtonOutlet: UIButton!
    @IBOutlet weak var usernameLogInTextField: UITextField!
    @IBOutlet weak var schoolNameLogInTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Adds some animations and effects to the views
        usernameLogInTextField.layer.opacity = 0
        schoolNameLogInTextField.layer.opacity = 0
        logInButtonOutlet.layer.opacity = 0
        signUpButtonOutlet.layer.opacity = 0
        
        logInButtonOutlet.layer.cornerRadius = 20
        signUpButtonOutlet.layer.cornerRadius = 20
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        // This handles the animations for the view
        UIView.animate(withDuration: 0.5, delay: 0.5) {
            self.usernameLogInTextField.layer.opacity = 1
            self.schoolNameLogInTextField.layer.opacity = 1
            self.logInButtonOutlet.layer.opacity = 1
            self.signUpButtonOutlet.layer.opacity = 1
        }
    }
    
    @IBAction func logInButtonAction(_ sender: UIButton) {
        
        // These are all the stored user sign in values
        usernameSignUp = (UserDefaults.standard.object(forKey: "UserNameSignUp") as? String) ?? ""
        schoolNameSignUp = (UserDefaults.standard.object(forKey: "SchoolNameSignUp") as? String) ?? ""
        firstNameSignUp = (UserDefaults.standard.object(forKey: "FirstNameSignUp") as? String) ?? ""
        lastNameSignUp = (UserDefaults.standard.object(forKey: "LastNameSignUp") as? String) ?? ""
        emailSignUp = (UserDefaults.standard.object(forKey: "EmailAddressSignUp") as? String) ?? ""
        schoolIDNumberSignUp = (UserDefaults.standard.object(forKey: "SchoolIDNumberSignUp") as? String) ?? ""
        
        
        // This checks the login credentials
        if usernameLogInTextField.text == usernameSignUp && schoolNameLogInTextField.text == schoolNameSignUp {
            performSegue(withIdentifier: "signedInSegue", sender: self)
            return
        }
        
        // This will present an invalid authentication alert if the user sign in was not succesfull
        let authAlert = UIAlertController(title: "Invalid Authentication", message: "Please enter a valid username and school.", preferredStyle: .actionSheet)
        
        authAlert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { dismissAuthAlert in
            
            authAlert.dismiss(animated: true, completion: nil)
        }))
        
        present(authAlert, animated: true, completion: nil)

    }
    
    // This is will make the keyboard go away when using a textfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
