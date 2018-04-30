//
//  HomeScreenViewController.swift
//  Crossword
//
//  Created by Justin Coberly on 4/22/18.
//  Copyright © 2018 Justin Coberly. All rights reserved.
//

import UIKit
import Firebase
import SpriteKit
import AVFoundation

class HomeViewController: UIViewController {
    
   
    var crosswordLevels : [CrosswordLevel] = [CrosswordLevel]()
    var userData = UserData()
    var backgroundMusic: AVAudioPlayer? = {
        let url = Bundle.main.url(forResource: "BackgroundMusic", withExtension: "mp3")
        do {
            let player = try AVAudioPlayer(contentsOf: url!)
            player.numberOfLoops = -1
            return player
        } catch {
            return nil
        }
    }()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playBackgroundMusic()
        loadPuzzles()
        collectionView?.dataSource = self
        
    }
    
    func playBackgroundMusic() {
        
        if UserDefaults.standard.bool(forKey: "SoundState") {
            backgroundMusic?.play()
            print("This FIRED")
        } else {
            print("not playing")
            backgroundMusic?.stop()
        }
        
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loadPuzzle" {
            let index = sender as! UIButton
            if let vc = segue.destination as? GameViewController {
                vc.levelData = crosswordLevels[index.tag]
            }
        }
    }
    
   
    
    func loadPuzzles() {
        
        let ref = Database.database().reference(withPath: "Crosswords/")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() { return }
            
            for item in snapshot.children {
                let level = CrosswordLevel(snapshot: item as! DataSnapshot)
                self.crosswordLevels.append(level)
                self.collectionView.reloadData()
            }
        })
    }
    
  
    
}


extension HomeViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return crosswordLevels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LevelCell", for: indexPath) as! LevelCellCollectionViewCell
    
        cell.levelNumber.text = crosswordLevels[indexPath.row].level
        cell.levelicon.tag = Int(crosswordLevels[indexPath.row].level)! - 1
       
        if let data = UserDefaults.standard.value(forKey: String(indexPath.row + 1)) as? Data {
            
            let userGuesses = try! PropertyListDecoder().decode(userLevelData.self , from: data)
            
            if userGuesses.isComplete {
                print(userGuesses)
                cell.completed.isHidden = false
            } else {
                cell.completed.isHidden = true
            }
        }
            
        
        return cell
    }
}
