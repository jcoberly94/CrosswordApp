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
    
    @IBOutlet var crosswordButton: [UIButton]!
    
    var selectedButton = -1
    let levelOne = CrosswordLevel1()
    
    override func viewDidLoad() {
        loadCrossword()
    }
    
    
    
    @IBAction func crosswordTouched(_ sender: UIButton) {
        if selectedButton >= 0 {
            crosswordButton[selectedButton].layer.borderColor = UIColor.white.cgColor
        }
        
        selectedButton = sender.tag
        print("selected button: \(selectedButton)")
        sender.layer.borderColor = UIColor.red.cgColor
        
    }
    
    func moveSelectedButtonRight() {
        
        crosswordButton[selectedButton].setTitleColor(UIColor.black, for: .normal)
        crosswordButton[selectedButton].layer.borderColor = UIColor.white.cgColor
        selectedButton += 1
        crosswordButton[selectedButton].layer.borderColor = UIColor.red.cgColor
    }
    
    @IBAction func KeyboardTouched(_ sender: UIButton) {
        let letter = String(UnicodeScalar(UInt8(sender.tag)))
        
        if selectedButton >= 0 {
            crosswordButton[selectedButton].setTitle(letter, for: .normal)
            moveSelectedButtonRight()
        }
    }
    
    func loadCrossword() {
        for button in crosswordButton {
            if levelOne.data[button.tag] != "-" {
                button.setTitle(levelOne.data[button.tag], for: .normal)
                button.backgroundColor = UIColor.white
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.white.cgColor
            } else {
                button.isEnabled = false
                button.setTitle(" ", for: .disabled)
                button.backgroundColor = UIColor.black
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.black.cgColor
            }
            
        }
    }
    
}
