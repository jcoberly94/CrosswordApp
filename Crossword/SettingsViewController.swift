//
//  SettingsViewController.swift
//  Crossword
//
//  Created by Justin Coberly on 4/29/18.
//  Copyright © 2018 Justin Coberly. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet var music: UISwitch!
    
    @IBAction func music(_ sender: UISwitch) {
        if sender.isOn {
            print("SoundState")
            UserDefaults.standard.set(true, forKey: "SoundState")
        } else {
            print("Sound state off")
            UserDefaults.standard.set(false, forKey: "SoundState")
        }
    }
}
