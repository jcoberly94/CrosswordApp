//
//  GameViewController.swift
//  Crossword
//
//  Created by Justin Coberly on 4/16/18.
//  Copyright © 2018 Justin Coberly. All rights reserved.
//

import UIKit
import FCAlertView

struct userLevelData:Codable {
    var level: String
    var isComplete: Bool
    var userData: [String]
    
    init(level: String, isComplete: Bool, userData: [String]){
        self.level = level
        self.isComplete = isComplete
        self.userData = userData
        for index in 0..<userData.count {
            if userData[index] != "-" {
                self.userData[index] = " "
            }
        }
    }
}

class GameViewController: UIViewController {
    //MARK: UIButtons
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet var crosswordButton: [UIButton]!
    @IBOutlet var keyboardButtons: [UIButton]!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var LevelNumber: UILabel!
    
    //MARK: Global Variables
    var selectedButton = -1
    var levelData = CrosswordLevel()
    var isHorizontal = true
    var hintList = [Word]()
    var userGuesses = userLevelData(level: " ", isComplete: false, userData: [])
    var markers = [Int]()
    
    
    
    
    //MARK: Load Data
    override func viewDidLoad() {
        if let data = UserDefaults.standard.value(forKey: levelData.level) as? Data {
            userGuesses = try! PropertyListDecoder().decode(userLevelData.self , from: data)
            //print(userGuesses)
            
            loadCrossword()
        } else {
            userGuesses = userLevelData(level: levelData.level, isComplete: false, userData: levelData.crosswordData)
            print("else: \(userGuesses)")
            UserDefaults.standard.set(try? PropertyListEncoder().encode(userGuesses), forKey: levelData.level)
            loadCrossword()
        }

        loadMarkers()
        loadHints()
        styleKeyboard()
        tapGesture.numberOfTapsRequired = 2
    }
    
    //MARK: Save Data
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            print("leaving view")
            savePuzzle()
            UserDefaults.standard.set(try? PropertyListEncoder().encode(userGuesses), forKey: levelData.level)
            print(userGuesses)
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
            if let buttonValue = button.titleLabel?.text {
            
            if levelData.crosswordData[button.tag] != buttonValue.lowercased() && levelData.crosswordData[button.tag] != "-"{
                print("Expected: \(levelData.crosswordData[button.tag])")
                print("Received: \(buttonValue.lowercased())")
                button.layer.borderColor = UIColor.red.cgColor
                isSolved = false
            }
        }
        }
        
        if isSolved {
            print("CONGRATS YOU Solved the Puzzle!")
            let alert = FCAlertView()
            alert.cornerRadius = 4
            alert.dismissOnOutsideTouch = true
            alert.showAlert(inView: self, withTitle: "Congrats!", withSubtitle: "You solved the puzzle", withCustomImage: nil, withDoneButtonTitle: "Done", andButtons: nil)
            userGuesses.isComplete = true
        } else {
            print("Sorry try again")
            let alert = FCAlertView()
            alert.cornerRadius = 4
            alert.dismissOnOutsideTouch = true
            alert.showAlert(inView: self, withTitle: "Sorry! Try Again", withSubtitle: "Some words are not correct", withCustomImage: nil, withDoneButtonTitle: "Done", andButtons: nil)
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
        LevelNumber.text = "Level \(levelData.level)"
    
        for button in crosswordButton {
            
            if levelData.crosswordData[button.tag] != "-" {
                
                button.setTitle(userGuesses.userData[button.tag], for: .normal)
                button.setTitleColor(UIColor.black, for: .normal)
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
    
    func loadMarkers() {
        
            for word in levelData.words {
                let row = word.row
                let column = word.column
                
                let index = Int(row)! * 13 + Int(column)!
                if (word.direction == "horizontal") {
                    crosswordButton[index].setBackgroundImage(UIImage(named: "\(word.row).png"), for: UIControlState.normal)
                } else {
                    crosswordButton[index].setBackgroundImage(UIImage(named: "\(word.column).png"), for: UIControlState.normal)
                }
                
            }
        
        
        
    }
    
    func savePuzzle() {
        for button in crosswordButton {
            let buttonValue = button.titleLabel?.text
            userGuesses.userData[button.tag] = buttonValue!
        }
    }
    
}
