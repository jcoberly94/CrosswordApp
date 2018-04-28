//
//  GameViewController.swift
//  Crossword
//
//  Created by Justin Coberly on 4/16/18.
//  Copyright © 2018 Justin Coberly. All rights reserved.
//

import UIKit


class GameViewController: UIViewController {
    //MARK: UIButtons
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet var crosswordButton: [UIButton]!
    @IBOutlet var keyboardButtons: [UIButton]!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    //MARK: Global Variables
    var selectedButton = -1
    var levelData = CrosswordLevel()
    var isHorizontal = true
    var hintList = [Word]()
    var userG: Dictionary = [Int : String]()
    
    
    
    //MARK: Load Data
    override func viewDidLoad() {
        loadCrossword()
        loadHints()
        styleKeyboard()
        tapGesture.numberOfTapsRequired = 2
    }
    
    //MARK: Save Data
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            print("leaving view")
        }
    }
    
    //MARK: Button Events
    @IBAction func doubleTapped(_ sender: UITapGestureRecognizer) {
        isHorizontal = false
        crosswordButton[selectedButton].layer.borderColor = UIColor.green.cgColor
        loadHint(button: selectedButton)
    }
    
    @IBAction func crosswordTouched(_ sender: UIButton) {
        if selectedButton >= 0 {
            crosswordButton[selectedButton].layer.borderColor = UIColor.black.cgColor
        }
        
        selectedButton = sender.tag
        
        isHorizontal = true
        loadHint(button: selectedButton)
        sender.layer.borderColor = UIColor.red.cgColor
        
    }
    
    
    @IBAction func solveButtonPressed(_ sender: UIButton) {
        var isSolved = true
        
        for button in crosswordButton {
            let buttonValue = button.titleLabel?.text
            
            if levelData.dataSet[button.tag] != buttonValue && buttonValue != " " {
                print("invalid input \(describing: buttonValue)")
                isSolved = false
            } else {
                print("valid input \(describing: buttonValue)")
            }
        }
        if isSolved {
            print("CONGRATS YOU Solved the Puzzle!")
        } else {
            print("Sorry try again")
        }
    }
    
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        if selectedButton >= 13 && selectedButton <= 155 {
            crosswordButton[selectedButton].setTitle(" ", for: .normal)
            if isHorizontal {
                if crosswordButton[selectedButton - 1].isEnabled {
                    moveSelectedButtonLeft()
                }
            } else {
                if crosswordButton[selectedButton - 13].isEnabled {
                    moveSelectedButtonUp()
                }
            }
        }
    }
    
    @IBAction func KeyboardTouched(_ sender: UIButton) {
        let letter = String(UnicodeScalar(UInt8(sender.tag)))
        
        if selectedButton >= 0 && selectedButton <= 155 {
            
            
            crosswordButton[selectedButton].setTitle(letter, for: .normal)
            crosswordButton[selectedButton].setTitleColor(UIColor.black, for: .normal)
            
            if isHorizontal {
                if crosswordButton[selectedButton + 1].isEnabled {
                    moveSelectedButtonRight()
                }
                
            } else {
                if crosswordButton[selectedButton + 13].isEnabled {
                    moveSelectedButtonDown()
                }
            }
        }
    }
    
    func styleKeyboard() {
        for button in keyboardButtons {
            button.layer.cornerRadius = 6
            button.clipsToBounds = true
        }
    }
    
    func moveSelectedButtonRight() {
        
        crosswordButton[selectedButton].setTitleColor(UIColor.black, for: .normal)
        crosswordButton[selectedButton].layer.borderColor = UIColor.black.cgColor
        selectedButton += 1
        crosswordButton[selectedButton].layer.borderColor = UIColor.red.cgColor
    }
    
    func moveSelectedButtonDown() {
        
        crosswordButton[selectedButton].setTitleColor(UIColor.black, for: .normal)
        crosswordButton[selectedButton].layer.borderColor = UIColor.black.cgColor
        selectedButton += 13
        crosswordButton[selectedButton].layer.borderColor = UIColor.green.cgColor
    }
    
    func moveSelectedButtonUp() {
        
        crosswordButton[selectedButton].setTitleColor(UIColor.black, for: .normal)
        crosswordButton[selectedButton].layer.borderColor = UIColor.black.cgColor
        selectedButton -= 13
        crosswordButton[selectedButton].layer.borderColor = UIColor.green.cgColor
    }
    
    func moveSelectedButtonLeft() {
        
        crosswordButton[selectedButton].setTitleColor(UIColor.black, for: .normal)
        crosswordButton[selectedButton].layer.borderColor = UIColor.black.cgColor
        selectedButton -= 1
        crosswordButton[selectedButton].layer.borderColor = UIColor.red.cgColor
    }
    
    
    
    
    func loadCrossword() {
        
        //var userCrosswordGuesses = levelData.dataSet
        
        
        
        for button in crosswordButton {
            
            
            if levelData.crosswordData[button.tag] != "-" {
                
                    
                
                //button.setTitle(levelData.crosswordData[button.tag], for: .normal)
                button.setTitle(" ", for: .normal)
                button.backgroundColor = UIColor.white
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.black.cgColor
                
            } else {
                button.isEnabled = false
                button.setTitle(" ", for: .disabled)
                button.backgroundColor = UIColor.black
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.black.cgColor
            }
            
        }
    }
    
    func loadHints() {
        for word in levelData.words {
            hintList.append(word)
        }
    }
    
    func loadHint(button: Int) {
        let row = String(button / 13)
        let column = String(button % 13)
        if isHorizontal {
            for word in hintList {
                let indexValue = Int(word.row)! * 13 + Int(word.column)!
                if (row == word.row && word.direction == "horizontal" && button >= indexValue) {
                    hintLabel.text = word.row + "a: " + word.hint
                    return
                }
            }
        }
        if isHorizontal == false {
            for word in hintList {
                let indexValue = Int(word.row)! * 13 + Int(word.column)!
                if (column == word.column && word.direction == "vertical" && button >= indexValue) {
                    hintLabel.text = word.column + "d: " + word.hint
                    return
                }
            }
        }
    }
    
    func savePuzzle() {
        
    }
    
}
