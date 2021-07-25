//
//  SignUpViewController.swift
//  ContacTrak
//
//  Created by Krish Iyengar, Sashank Balusu, Pranit Agrawal on 7/23/21.
//

import UIKit

// This is the view controller that displays all of the people that the user has come into contact with
class ShowContactsTracerViewController: UIViewController {
    
    // This is a tableview outlet
    @IBOutlet weak var showContactsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // This allows the user to get back to the main screen view controller by swiping right
        let swipeGestureRecognizerAllContacts = UISwipeGestureRecognizer(target: self, action: #selector(swipeScrenContactsNumber))
        swipeGestureRecognizerAllContacts.direction = .right
        showContactsTableView.addGestureRecognizer(swipeGestureRecognizerAllContacts)
        showContactsTableView.isUserInteractionEnabled = true
    }
    
    // This is the function the gesture recognizer calls when the user swipes rights
    // This function performs a segue, so the view gets transferred to the main screen view controller
    @objc func swipeScrenContactsNumber() {
        performSegue(withIdentifier: "contactsNumberSegue", sender: self)
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
// This is an extension of the ShowContactsTracerViewController that conforms to the UITableViewDelegate protocol
extension ShowContactsTracerViewController: UITableViewDelegate {
    
}
// This is an extension of the ShowContactsTracerViewController that conforms to the UITableViewDataSource protocol
extension ShowContactsTracerViewController: UITableViewDataSource {
    // This is hte number of contacts that were currently recorded
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPeripheralsContacted.count
    }
    // HEre I use a table view cell to set the name and time when the person came into contact with the user
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let oneContactsTracerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "contactsTracerCell") ?? UITableViewCell()
        
        oneContactsTracerTableViewCell.textLabel?.text = allPeripheralsContacted[indexPath.row][0]
        oneContactsTracerTableViewCell.detailTextLabel?.text = allPeripheralsContacted[indexPath.row][1]
        
        return oneContactsTracerTableViewCell
        
    }
    
    
}
