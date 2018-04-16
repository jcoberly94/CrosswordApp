//
//  GameViewController.swift
//  Crossword
//
//  Created by Justin Coberly on 4/16/18.
//  Copyright © 2018 Justin Coberly. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var hintLabel: UILabel!
    
    @IBAction func KeyboardTouched(_ sender: UIButton) {
        let letter = UnicodeScalar(UInt8(sender.tag))
        print("\(letter) button pressed")
    }
    
}
