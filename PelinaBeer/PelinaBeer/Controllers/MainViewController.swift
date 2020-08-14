//
//  ViewController.swift
//  PelinaBeer
//
//  Created by Intellisys on 8/13/20.
//  Copyright © 2020 Luis Tejada. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    
    let moviesCollectionView: UICollectionView = {
        
        let c = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        c.translatesAutoresizingMaskIntoConstraints = false
        c.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "movieCell")
        c.backgroundColor = .white
        return c
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
    
        configureLargueTitleWith(text: "Pelina Beer")
            
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        
        
        view.addSubview(moviesCollectionView)
        moviesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        moviesCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        moviesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        moviesCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }

}


extension MainViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        present(MovieDetailViewController(), animated: true, completion: nil)
    }
}

extension MainViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath)
        
        cell.backgroundColor = .red
        
        return cell
    }
}
