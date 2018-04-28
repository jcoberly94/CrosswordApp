//
//  CrosswordLevel1.swift
//  Crossword
//
//  Created by Justin Coberly on 4/22/18.
//  Copyright © 2018 Justin Coberly. All rights reserved.
//

import Foundation
import Firebase

class CrosswordLevel {
    
    var level = "level"
    
    var words = [Word]()
    var dataSet = [String]()
    var crosswordData = [String]()
    
//    var data = ["-","-","-","-","-","p","-","-","-","-","-","-","-",
//                "p","a","l","a","d","i","n","-","-","-","-","-","-",
//                "-","l","-","-","-","s","-","-","-","-","-","-","-",
//                "-","b","-","-","-","t","-","-","-","-","-","-","-",
//                "s","a","f","f","r","o","n","-","-","-","-","-","-",
//                "-","t","-","-","-","n","-","-","-","-","h","-","-",
//                "-","r","-","-","-","-","-","c","o","d","a","-","-",
//                "-","o","-","m","-","-","-","o","-","-","r","-","-",
//                "-","s","n","i","c","k","e","r","-","-","p","-","-",
//                "-","s","-","s","-","-","-","a","-","-","-","-","-",
//                "-","-","-","t","-","-","-","l","i","m","e","-","-",
//                "-","-","-","-","-","-","-","-","-","-","-","-","-",
//                "-","-","-","-","-","-","-","-","-","-","-","-","-"]
    
    init(snapshot: DataSnapshot) {
        level = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        crosswordData = snapshotValue["CrosswordData"] as! [String]
        for wordData in (snapshotValue["Words"] as! NSArray) {
            words.append(Word(snapshotValue: wordData as! NSDictionary))
        }
        
       
    }
    init() {
        
    }
}
