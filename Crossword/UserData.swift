//
//  UserData.swift
//  Crossword
//
//  Created by Justin Coberly on 4/28/18.
//  Copyright © 2018 Justin Coberly. All rights reserved.
//

import Foundation
import SpriteKit
let soundState = "SoundState"

class UserData {
    init() {}
    
    func setSounds(_ state: Bool) {
        UserDefaults.standard.set(state, forKey: soundState)
        UserDefaults.standard.synchronize()
    }
    
    func getSound() -> Bool {
        return UserDefaults.standard.bool(forKey: soundState)
    }
}
