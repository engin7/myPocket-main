//
//  Entry.swift
//  My Pocket
//
//  Created by Engin KUK on 2.12.2020.
//

import Foundation
import FMDB

@objcMembers class Entry: NSObject {
     
    var entryID: Int
    var type: Bool //income true, expense false
    var title: String
    var amount: Int
    
    @objc public init(entryID: Int,type: Bool, title: String, amount: Int) {
        self.entryID = entryID
        self.type = type
        self.title = title
        self.amount = amount
    }
     
}
