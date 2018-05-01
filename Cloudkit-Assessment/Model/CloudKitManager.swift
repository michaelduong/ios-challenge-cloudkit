//
//  CloudKitManager.swift
//  Cloudkit-Assessment
//
//  Created by Michael Duong on 2/9/18.
//  Copyright © 2018 Turnt Labs. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitManager {
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    func save(for contact: Contact) {
        publicDB.save(contact.asCKRecord) { (record, error) in
            if let error = error {
                print("Error saving contact: \(error.localizedDescription)")
            }
                guard let record = record else { return }
                contact.id = record.recordID
                print("Successfully saved contact to CloudKit")
            
        }
    }
    
    func save(for record: CKRecord) {
        publicDB.save(record) { (_, error) in
            if let error = error {
                print("Error saving record: \(error.localizedDescription)")
            } else {
                print("Successfully saved record to CloudKit")
            }
        }
    }
    
    func update(contact: Contact, completion: @escaping ((CKRecord?, Error?) -> Void)) {
        guard let id = contact.id else { return }
        publicDB.fetch(withRecordID: id, completionHandler: completion)
    }
    
    
    func delete(contact: CKRecord, completion: @escaping ((Bool) -> Void)) {
        CKContainer.default().publicCloudDatabase.delete(withRecordID: contact.recordID) { (_, error) in
            if let error = error {
                print("Error deleting contact. Error:\(error) - \(error.localizedDescription)")
            } else {
                print("Successfully deleted contact")
            }
        }
    }
    
    func load(recordType: String, completion: @escaping (([CKRecord]?, Error?) -> Void)) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: recordType, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil, completionHandler: completion)
    }

}
