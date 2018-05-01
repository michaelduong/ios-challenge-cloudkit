//
//  Contact.swift
//  Cloudkit-Assessment
//
//  Created by Michael Duong on 2/9/18.
//  Copyright © 2018 Turnt Labs. All rights reserved.
//

import Foundation
import CloudKit

class Contact {
    
    var name: String
    var phone: String
    var email: String
    var id: CKRecordID?
    
    
    init(name: String, phone: String, email: String) {
        self.name = name
        self.phone = phone
        self.email = email
        self.id = nil
    }
    
    init?(record: CKRecord) {
        guard let name = record.object(forKey: CloudKitKeys.name) as? String,
            let phone = record.object(forKey: CloudKitKeys.phone) as? String,
            let email = record.object(forKey: CloudKitKeys.email) as? String
            else { return nil }
        
        self.name = name
        self.phone = phone
        self.email = email
        self.id = record.recordID
    }
    
    var asCKRecord: CKRecord {
        let record: CKRecord
        
        if id == nil {
            record = CKRecord(recordType: CloudKitKeys.type)
        } else {
            record = CKRecord(recordType: CloudKitKeys.type, recordID: id!)
        }
        
        record[CloudKitKeys.name] = self.name as CKRecordValue
        record[CloudKitKeys.phone] = self.phone as CKRecordValue
        record[CloudKitKeys.email] = self.email as CKRecordValue
        
        return record
    }
}
