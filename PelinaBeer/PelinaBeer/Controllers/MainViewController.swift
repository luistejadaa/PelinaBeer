//
//  ViewController.swift
//  PelinaBeer
//
//  Created by Intellisys on 8/13/20.
//  Copyright © 2020 Luis Tejada. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    
    let filterView : FilterView = {
       
        let f = FilterView(frame: .zero)
        f.translatesAutoresizingMaskIntoConstraints = false
        return f
    }()
    
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
        view.addSubview(filterView)
        
        moviesCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        moviesCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        moviesCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        moviesCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        addIRightItem(image: #imageLiteral(resourceName: "sort_icon"), action: #selector(showFilter))
        addIRightItem(image: #imageLiteral(resourceName: "filterFill_icon"), action: #selector(showFilter))
        
    }
    
    @objc func showFilter() {
        
        present(FilterViewController(), animated: true, completion: nil)
    }
    
    @objc func showSort() {
        
    }
}


extension MainViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        present(MovieDetailViewController(movie: Movie(name: "Título", synopsis: "Sypnoasdnsaodnoasdaosdnaos", imageURL: nil, calification: nil, publishDate: nil)), animated: true, completion: nil)
    }
}

extension MainViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath)
        cell.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.1026628521)
        cell.layer.cornerRadius = 8
        cell.addSimpleShadow()
        return cell
    }
}

extension MainViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = view.frame.width / 2
        return CGSize(width: size - 20, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 8, left: 13, bottom: 8, right: 13)
    }
}
