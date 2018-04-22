//
//  HomeScreenViewController.swift
//  Crossword
//
//  Created by Justin Coberly on 4/22/18.
//  Copyright © 2018 Justin Coberly. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.dataSource = self
    }
    
}


extension HomeViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LevelCell", for: indexPath) as! LevelCellCollectionViewCell
        
        cell.levelNumber.text = "2"
        
        
        return cell
    }
}
