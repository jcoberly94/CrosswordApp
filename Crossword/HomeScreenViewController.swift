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
            if let vc = segue.destination as? GameViewController {
                print("segue")
                vc.levelData = crosswordLevels[0]
                
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
        
        return cell
    }
}
