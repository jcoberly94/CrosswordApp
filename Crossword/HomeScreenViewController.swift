//
//  HomeScreenViewController.swift
//  Crossword
//
//  Created by Justin Coberly on 4/22/18.
//  Copyright © 2018 Justin Coberly. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    
   
    var crosswordLevels : [CrosswordLevel] = [CrosswordLevel]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPuzzles()
        collectionView?.dataSource = self
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loadPuzzle" {
            let index = sender as! UIButton
            
            
            print("INDEX: \(index)")
            if let vc = segue.destination as? GameViewController {
                print("segue")
                
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
                cell.completed.isHidden = false
            }
        }
            
        
        return cell
    }
}
