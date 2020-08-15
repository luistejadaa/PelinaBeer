//
//  ViewController.swift
//  PelinaBeer
//
//  Created by Intellisys on 8/13/20.
//  Copyright © 2020 Luis Tejada. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    
    
    var movies : [Movie]?
    var filteredMovies : [Movie]?
    
    let filterView : FilterView = {
        
        let f = FilterView(frame: .zero)
        f.translatesAutoresizingMaskIntoConstraints = false
        return f
    }()
    
    let moviesCollectionView: UICollectionView = {
        
        let c = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        c.translatesAutoresizingMaskIntoConstraints = false
        c.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "movieCell")
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
        
        discoverMovies()
        
        
    }
    
    func discoverMovies() {
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            Movie.discoverMovies { (response) in
                
                switch response {
                    
                case .success(let result):
                    
                    self.movies = result.results
                    self.moviesCollectionView.reloadData()
                    
                case .failure(let error):
                    
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
                    DispatchQueue.main.async {
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @objc func showFilter() {
        
        present(FilterViewController(), animated: true, completion: nil)
    }
    
    @objc func showSort() {
        
    }
}


extension MainViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
}

extension MainViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        
        if self.movies![indexPath.row].thumbailImage == nil {
            
            cell.activityIindicator.startAnimating()
            
            DispatchQueue(label: "downloadThumbnail").async {
                
                self.movies![indexPath.row].getThumnailImage {
                    
                    self.setImageToCell(cell: cell, indexPath: indexPath)
                }
            }
            
        } else {
            
            setImageToCell(cell: cell, indexPath: indexPath)
        }
        
        return cell
    }
    
    func setImageToCell(cell: MovieCollectionViewCell, indexPath: IndexPath) {
        
        DispatchQueue.main.async {
            
            cell.movieImageView.image = self.movies![indexPath.row].thumbailImage
            cell.activityIindicator.stopAnimating()
        }
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
