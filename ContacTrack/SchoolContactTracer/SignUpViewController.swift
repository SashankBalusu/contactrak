//
//  SignUpViewController.swift
//  ContacTrak
//
//  Created by Krish Iyengar, Sashank Balusu, Pranit Agrawal on 7/23/21.
//

import UIKit

// This is the view controller that the user signs up through
class SignUpViewController: UIViewController {

    // These are the view controller outlets
    @IBOutlet weak var signUpButtonOutlet: UIButton!
    @IBOutlet weak var logInButtonOutlet: UIButton!
    @IBOutlet weak var firstNameSignUpTextField: UITextField!
    @IBOutlet weak var lastNameSignUpTextField: UITextField!
    @IBOutlet weak var usernameSignUpTextFIeld: UITextField!
    @IBOutlet weak var schoolIDSignUpTextFIeld: UITextField!
    @IBOutlet weak var schoolNameSignUpTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Styling and animation code
        logInButtonOutlet.layer.cornerRadius = 20
        signUpButtonOutlet.layer.cornerRadius = 20
        
        self.firstNameSignUpTextField.transform = CGAffineTransform(translationX: -700, y: 0)
        self.lastNameSignUpTextField.transform = CGAffineTransform(translationX: -700, y: 0)
        self.usernameSignUpTextFIeld.transform = CGAffineTransform(translationX: -700, y: 0)
        self.schoolIDSignUpTextFIeld.transform = CGAffineTransform(translationX: -700, y: 0)
        self.schoolNameSignUpTextField.transform = CGAffineTransform(translationX: -700, y: 0)
        self.emailAddressTextField.transform = CGAffineTransform(translationX: -700, y: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // This is the animation code
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.firstNameSignUpTextField.transform = .identity
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.25, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.lastNameSignUpTextField.transform = .identity
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.emailAddressTextField.transform = .identity
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.usernameSignUpTextFIeld.transform = .identity
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.schoolIDSignUpTextFIeld.transform = .identity
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 1.25, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.schoolNameSignUpTextField.transform = .identity
        }, completion: nil)
        
    }
    
    // This is used to dismiss the keyboard when editing a textfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func signUpAction(_ sender: UIButton) {
        
        // This removes all of the current objects data in those specified keys
        UserDefaults.standard.removeObject(forKey: "FirstNameSignUp")
        UserDefaults.standard.removeObject(forKey: "LastNameSignUp")
        UserDefaults.standard.removeObject(forKey: "UserNameSignUp")
        UserDefaults.standard.removeObject(forKey: "SchoolIDNumberSignUp")
        UserDefaults.standard.removeObject(forKey: "SchoolNameSignUp")
        UserDefaults.standard.removeObject(forKey: "EmailAddressSignUp")
        
        // This sets all of the data in the specified keys
        UserDefaults.standard.set(firstNameSignUpTextField.text, forKey: "FirstNameSignUp")
        UserDefaults.standard.set(lastNameSignUpTextField.text, forKey: "LastNameSignUp")
        UserDefaults.standard.set(usernameSignUpTextFIeld.text, forKey: "UserNameSignUp")
        UserDefaults.standard.set(schoolIDSignUpTextFIeld.text, forKey: "SchoolIDNumberSignUp")
        UserDefaults.standard.set(schoolNameSignUpTextField.text, forKey: "SchoolNameSignUp")
        UserDefaults.standard.set(emailAddressTextField.text, forKey: "EmailAddressSignUp")

        // This will set all fo the variables within the app to contain the values the user entered
        usernameSignUp = usernameSignUpTextFIeld.text ?? ""
        schoolNameSignUp = schoolNameSignUpTextField.text ?? ""
        firstNameSignUp = firstNameSignUpTextField.text ?? ""
        lastNameSignUp = lastNameSignUpTextField.text ?? ""
        schoolIDNumberSignUp = schoolIDSignUpTextFIeld.text ?? ""
        emailSignUp = emailAddressTextField.text ?? ""
        
        // Moves the screen to the signed in contacts view controller
        performSegue(withIdentifier: "signedUpSegue", sender: self)
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
