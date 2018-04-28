//
//  Word.swift
//  Crossword
//
//  Created by Justin Coberly on 4/22/18.
//  Copyright © 2018 Justin Coberly. All rights reserved.
//

import Foundation
import Firebase

class Word {
    var word : String
    var column : String
    var row : String
    var direction : String
    var hint : String
    var key = "0"
    
    
    init(word : String, column : String, row : String, direction : String, hint : String) {
        self.word = word
        self.column = column
        self.row = row
        self.direction = direction
        self.hint = hint
    }
    
    init(snapshotValue: NSDictionary) {
        
        self.word = snapshotValue["word"] as! String
        self.column = snapshotValue["column"] as! String
        self.row = snapshotValue["row"] as! String
        self.hint = snapshotValue["hint"] as! String
        self.direction = snapshotValue["direction"] as! String
        
    }
    
}
