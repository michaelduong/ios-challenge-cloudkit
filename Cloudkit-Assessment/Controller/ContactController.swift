//
//  ContactController.swift
//  Cloudkit-Assessment
//
//  Created by Michael Duong on 2/9/18.
//  Copyright © 2018 Turnt Labs. All rights reserved.
//

import Foundation
import CloudKit

class ContactController {
    
    static let shared = ContactController()
    
    let ckManager = CloudKitManager()
    var contacts = [Contact]() {
        didSet {
            NotificationCenter.default.post(name: NotificationKey.notificationUpdating, object: self)
        }
    }
    
    init() {
        loadContacts(recordType: CloudKitKeys.type)
    }
    
    func addContact(name: String, phone: String, email: String) {
        let contact = Contact(name: name, phone: phone, email: email)
        contacts.append(contact)
        ckManager.save(for: contact)
    }
    
    func updateContact(contact: Contact, name: String, phone: String, email: String) {
        contact.name = name
        contact.phone = phone
        contact.email = email
        
        ckManager.update(contact: contact) { (record, error) in
            if let error = error {
                print("Error fetching contact: \(error.localizedDescription)")
                return
            }
            guard let record = record else {
                print("No record exists")
                return
            }
            record[CloudKitKeys.name] = name as CKRecordValue
            record[CloudKitKeys.phone] = phone as CKRecordValue
            record[CloudKitKeys.email] = email as CKRecordValue
            self.ckManager.save(for: record)
        }
    }


    
    func deleteContact(contact: Contact) {
        ckManager.delete(contact: contact.asCKRecord) { (success) in
            if success {
                print("Successfully deleted contact.")
            }else{
                print("Error deleting contact.")
            }
        }
    }
    
    func loadContacts(recordType: String) {
        ckManager.load(recordType: recordType) { (records, error) in
            if let error = error {
                print("Error loading contacts: \(error.localizedDescription)")
                return
            }
            guard let records = records else { return }
            
            for record in records {
                guard let contact = Contact(record: record) else { continue }
                self.contacts.append(contact)
            }
        }
    }
}

