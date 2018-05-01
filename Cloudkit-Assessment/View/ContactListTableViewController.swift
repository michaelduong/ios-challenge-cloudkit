//
//  ContactListTableViewController.swift
//  Cloudkit-Assessment
//
//  Created by Michael Duong on 2/9/18.
//  Copyright © 2018 Turnt Labs. All rights reserved.
//

import UIKit

class ContactListTableViewController: UITableViewController {

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateView), name: NotificationKey.notificationUpdating, object: nil)
    }
    
    @objc func updateView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ContactController.shared.contacts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contacts = ContactController.shared.contacts[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        
        cell.textLabel?.text = contacts.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let contactDelete = ContactController.shared.contacts[indexPath.row]
            
            ContactController.shared.deleteContact(contact: contactDelete)
            
            ContactController.shared.contacts.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.reloadData()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toContactDetail" {
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let contact = ContactController.shared.contacts[indexPath.row]
            
            guard let destination = segue.destination as? ContactDetailViewController else { return }
            
            destination.contact = contact
        }
    }

}
