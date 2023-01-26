//
//  EntryError.swift
//  JournalCloudKit
//
//  Created by Stef Castillo on 1/25/23.
//

import Foundation

/**
  In this helper we are creating an enum to handle errors we get during our network calls
  */

enum EntryError: LocalizedError {
    case CKError(Error)
    case couldNotUnwrap
}
