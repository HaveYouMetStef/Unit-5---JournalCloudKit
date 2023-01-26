//
//  Entry Model.swift
//  JournalCloudKit
//
//  Created by Stef Castillo on 1/24/23.
//

import Foundation
import CloudKit

class Entry{
    //MARK: - Properties
    var title: String
    var body: String
    let timestamp: Date
    let ckRecordID: CKRecord.ID
    
    //MARK: - Initializers
    init(title: String, body: String, timestamp: Date = Date(), ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.body = body
        self.timestamp = timestamp
        self.ckRecordID = ckRecordID
    }
    
    //MARK: - Failable Initializer
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[EntryConstants.TitleKey] as? String,
              let body = ckRecord[EntryConstants.BodyKey] as? String,
              let timestamp = ckRecord[EntryConstants.TimestampKey] as? Date else { return nil}
        self.init(title: title, body: body, timestamp: timestamp, ckRecordID: ckRecord.recordID)
    }
}

//MARK: - CKRecord Entry Convenience Initializer
extension CKRecord{
    convenience init(entry: Entry) {
        self.init(recordType: EntryConstants.RecordType, recordID: entry.ckRecordID)
        self.setValue(entry.title, forKey: EntryConstants.TitleKey)
        self.setValue(entry.body, forKey: EntryConstants.BodyKey)
        self.setValue(entry.timestamp, forKey: EntryConstants.TimestampKey)
    }
}

//MARK: - Entry Contants
struct EntryConstants {
    static let TitleKey = "title"
    static let BodyKey = "body"
    static let TimestampKey = "timestamp"
    static let RecordType = "Entry"
}
