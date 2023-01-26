//
//  EntryDetailViewController.swift
//  JournalCloudKit
//
//  Created by Stef Castillo on 1/25/23.
//

import UIKit

class EntryDetailViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextField!
    
    
    
    
    //MARK: Properties
    var entry : Entry? {
        //Place a didSet on the entry property which calls loadViewIfNeeded
        didSet {
            DispatchQueue.main.async {
                self.loadViewIfNeeded()
                self.updateViews()
            }
        }
    }
    
    
//MARK: lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    

        titleTextField.delegate = self
    }
    
    //MARK: Methods
    
    func updateViews() {
        //checks if the optional entry property holds an entry. If it does, implement the function to update all view elements that reflect details about the model object entry
        guard let entry = entry else { return }
        titleTextField.text = entry.title
        bodyTextView.text = entry.body
    }
    
    //Implement the delegate function textFieldShouldReturn and resign first responder to dismiss the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //This will allow the user to dismiss the keyboard by touching anywhere on the outer screen.
        titleTextField.resignFirstResponder()
        bodyTextView.resignFirstResponder()
        return true
    }
    
    //MARK: Actions
    @IBAction func mainViewTapped(_ sender: UITapGestureRecognizer) {

    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        
        //clears the text in the titleTextField and bodyTextView
        titleTextField.text = ""
        bodyTextView.text = ""
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        
        //guard against the title and body being empty or nil, then call the createEntryWith(title: ...) using the shared instance of the EntryController
        guard let title = titleTextField.text, !title.isEmpty,
              let body = bodyTextView.text, !body.isEmpty
        else { return }
        
        EntryController.shared.createEntryWith(with: title, body: body) { (result) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
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
