//
//  ContactDetailViewController.swift
//  Cloudkit-Assessment
//
//  Created by Michael Duong on 2/9/18.
//  Copyright © 2018 Turnt Labs. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var contact: Contact? {
        didSet {
            if isViewLoaded {
                updateViews()
            }
        }
    }
    
    func updateViews() {
        guard let contact = contact else { return }
        nameTextField.text = contact.name
        phoneTextField.text = contact.phone
        emailTextField.text = contact.email
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let name = nameTextField.text, name != "" else { return }
        guard let phone = phoneTextField.text, phone != "" else { return }
        guard let email = emailTextField.text, email != "" else { return }
        
        if let contact = contact {
            ContactController.shared.updateContact(contact: contact, name: name, phone: phone, email: email)
        } else {
            ContactController.shared.addContact(name: name, phone: phone, email: email)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
        
    }


}
