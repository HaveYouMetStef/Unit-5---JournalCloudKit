//
//  EntryController.swift
//  JournalCloudKit
//
//  Created by Stef Castillo on 1/25/23.
//

import Foundation
import CloudKit

class EntryController {
    
    //MARK: - shared instance
    static let shared = EntryController()
    
    
    let privateDB = CKContainer.default().privateCloudDatabase
    
    //MARK: - Source of Truth
    
    var entries : [Entry] = []
    
    //MARK: CRUD Functions
    //save
    func save(entry: Entry, completion: @escaping (_ result: Result<Entry?, EntryError>) -> Void) {
        let record = CKRecord(entry: entry)
        privateDB.save(record) { (record, error) in
            if let error = error {
                print("\(error.localizedDescription) \(error) in function \(#function)")
                completion(.failure(.CKError(error)))
                return
            }
            guard let record = record,
                  let entry = Entry(ckRecord: record) else { completion(.failure(.couldNotUnwrap)); return}
            self.entries.append(entry)
            completion(.success(entry))
        }
    }
    //create
    func createEntryWith(with title: String, body: String, completion: @escaping (_ result: Result<Entry?, EntryError>) -> Void) {
        let entry = Entry(title: title, body: body, timestamp: Date())
        save(entry: entry, completion: completion)
        
    }
    
    //fetch
    func fetchEntries(completion: @escaping (_ result: Result<[Entry]?, EntryError>) -> Void) {
        //we want to get all entries back from the private database so we will be using the initializer that takes in a value, and we will be setting that value to true This tells the predicate to just return everything.
        let predicate = NSPredicate(value: true)
        
        //In order to perform a query to the private database, you will need to create a CKQuery.
        let query = CKQuery(recordType: EntryConstants.RecordType, predicate: predicate)
        
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(.failure(.CKError(error)))
                return
            }
            guard let records = records else { completion(.failure(.couldNotUnwrap)) ; return }
            let entries = records.compactMap { Entry(ckRecord: $0)}
            self.entries = entries
            completion(.success(entries))
        }
    }
}

