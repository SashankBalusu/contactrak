//
//  MainScreenViewController.swift
//  ContacTrak
//
//  Created by Krish Iyengar, Sashank Balusu, Pranit Agrawal on 7/23/21.
//

import UIKit
import MessageUI

// This is the class that will handle the contact tracing
var contactTracingBluetooth: BluetoothContactTracer? = nil

// This is the view controller that the user can check the number of contacts they've had, export the contacts to a file, or email the people they've come into contact with
class MainScreenViewController: UIViewController {

    // These are the view controller outlets
    @IBOutlet weak var exportDataButton: UIButton!
    @IBOutlet weak var contactsLabel: UILabel!
    @IBOutlet weak var mailInfectedButton: UIButton!
    @IBOutlet weak var welcomeContactTracerLabel: UILabel!
    @IBOutlet weak var blurBackgroundViewOutlet: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // This will create a new BluetoothContactTracer object
        if contactTracingBluetooth == nil {
            contactTracingBluetooth = BluetoothContactTracer(contactTracerDelegate: self)
        }
        
        // This swipe gesture recognizer will be used to swipe through all of the pages
        let swipeGestureRecognizerAllContacts = UISwipeGestureRecognizer(target: self, action: #selector(swipeScreenAllContacts))
        swipeGestureRecognizerAllContacts.direction = .left
        blurBackgroundViewOutlet.addGestureRecognizer(swipeGestureRecognizerAllContacts)
        blurBackgroundViewOutlet.isUserInteractionEnabled = true
        
        welcomeContactTracerLabel.text = "Welcome, \(firstNameSignUp)"
        
        exportDataButton.layer.cornerRadius = 10
        mailInfectedButton.layer.cornerRadius = 10
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // This updates everytime the app switches between view controllers and back to this view controller
        self.contactsLabel.text = "\(allPeripheralsContacted.count)"
    }
    
    // This will show the showContactsTracerViewController
    @objc func swipeScreenAllContacts() {
        performSegue(withIdentifier: "allContactsSegue", sender: self)
    }
    
    
    @IBAction func mailInfectedAction(_ sender: UIButton) {
        
        // Sends the mail while getting all of the recipients from the contacted array
            guard MFMailComposeViewController.canSendMail() else{
                //show alert informing user
                return
            }
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            var emailAddressRecipients = [String]()
        for oneContactedPerson in allPeripheralsContacted {
            emailAddressRecipients.append(oneContactedPerson[2])
            
        }
            mail.setToRecipients(emailAddressRecipients)// Contacts
            mail.setSubject("You have been in close contact with someone who has COVID-19")
            mail.setMessageBody("This email is being sent to inform you that you have been deemed as in close contact with someone who has covid. Please take the necessary precautions, get tested, and stay home. Thanks!", isHTML: false)
            present(mail, animated:true)
            
    }

    @IBAction func exportDataAction(_ sender: UIButton) {
        
        // Gets a URL of a text file
        let currentExportFileData = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent("ContacTrakData.txt")
        
        // Generates the string to put it in the text file
        var contactData = "Contact Tracing for \(schoolNameSignUp)\n"
        
        var counter = 1
        for oneContactTracing in allPeripheralsContacted {
            contactData += "\(counter). Name: \(oneContactTracing[0]), Time: \(oneContactTracing[1])\n"
            counter += 1
        }
        
        // This writes the text to a text file in the url given and if there is an error an alert is displayed
        do {
            try contactData.write(to: currentExportFileData, atomically: true, encoding: .utf8)
        }
        catch {
            let errorAlert = UIAlertController(title: "ERROR Exporting Data", message: "Please try again.", preferredStyle: .actionSheet)
            
            errorAlert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { dismissAuthAlert in
                errorAlert.dismiss(animated: true, completion: nil)
            }))
            present(errorAlert, animated: true, completion: nil)
            
        }
        
        // Gives the URL to a sharesheeta nd presents the share sheet
        let exportDataActivityShareSheet = UIActivityViewController(activityItems: [currentExportFileData], applicationActivities: nil)
        
        present(exportDataActivityShareSheet, animated: true, completion: nil)
        
        
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
// This is the extension of the main screen view controller that conforms to the BluetoothContactTracerDelegate methods
extension MainScreenViewController: BluetoothContactTracerDelegate {
    
    // This method updates the counter variable for the number of contacts
    func updateNumberContacts() {
        DispatchQueue.main.async {
            self.contactsLabel.text = "\(allPeripheralsContacted.count)"
        }
    }
    
}
// This is the extension of the main screen view controller that gets the result of the finished mail composing view controller
extension MainScreenViewController: MFMailComposeViewControllerDelegate {
    // After the mail composing view controller is finished, it prints the result of what the user did with it and dismisses it
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error{
            // Dismisses the mail compose view controller
            controller.dismiss(animated:true)
            return
        }
        // Prints what the user did with the mail compose view controller
        switch result {
        case .cancelled:
            print("Cancelled")
        
        case .failed:
            print("Failed to send")
        case .saved:
            print("Saved")
        case .sent:
            print("Email Sent")
        }
        
        // Dismisses the mail compose view controller
        controller.dismiss(animated:true)
    }

}
