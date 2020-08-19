//
//  ViewController.swift
//  PelinaBeer
//
//  Created by Intellisys on 8/13/20.
//  Copyright © 2020 Luis Tejada. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    
    
    var movieDiscoverFilter : MovieDiscoverFilter!
    var movies = [Movie]()
    var filteredMovies = [Movie]()
    var totalPages : Int!
    var totalResults : Int!
    
    let filterView : FilterView = {
        
        let f = FilterView(frame: .zero)
        f.translatesAutoresizingMaskIntoConstraints = false
        return f
    }() 
    
    let fetchActivityIindicator: UIActivityIndicatorView = {
        let a = UIActivityIndicatorView(style: .medium)
        a.translatesAutoresizingMaskIntoConstraints = false
        a.color = .mainColor
        return a
    }()
    
    let moviesCollectionView: UICollectionView = {
        
        let c = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        (c.collectionViewLayout as! UICollectionViewFlowLayout).footerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 30)
        c.translatesAutoresizingMaskIntoConstraints = false
        c.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "movieCell")
        c.backgroundColor = .white
        c.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footerCell")
        return c
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieDiscoverFilter = MovieDiscoverFilter(pageNumber: 0, rating: nil, year: nil, genres: nil)
        totalPages = 0
        totalResults = 0
        view.backgroundColor = .white
        
        configureLargueTitleWith(text: "Pelina Beer")
        
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        moviesCollectionView.prefetchDataSource = self
        moviesCollectionView.refreshControl = UIRefreshControl()
        moviesCollectionView.refreshControl?.tintColor = .mainColor
        moviesCollectionView.refreshControl?.addTarget(self, action: #selector(refreshdData), for: .valueChanged)
        
        
        view.addSubview(moviesCollectionView)
        view.addSubview(filterView)
        
        moviesCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        moviesCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        moviesCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        moviesCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        addIRightItem(image: #imageLiteral(resourceName: "sort_icon"), action: #selector(showFilter))
        addIRightItem(image: #imageLiteral(resourceName: "filterFill_icon"), action: #selector(showFilter))
        
    }
    
    @objc func refreshdData() {
        
        
        DispatchQueue.main.async {
            
            if self.moviesCollectionView.refreshControl!.isRefreshing {
                
                self.movies.removeAll()
                self.moviesCollectionView.reloadData()
            }
        }
        
        discoverMovies()
    }
    
    @objc func discoverMovies() {
        
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            self.movieDiscoverFilter.pageNumber += 1
            Movie.discoverMovies(filter: self.movieDiscoverFilter) { (response) in
                
                DispatchQueue.main.async {
                    self.fetchActivityIindicator.stopAnimating()
                    self.moviesCollectionView.refreshControl?.endRefreshing()
                }
                
                switch response {
                case .success(let result):
                    
                    self.totalPages = result.total_pages
                    self.totalResults = result.total_results
                    if let movies = result.results {
                        
                        //Esto es para generar el efecto de que se cargan una a una
                        for m in movies {
                            
                            self.movies.append(m)
                            self.moviesCollectionView.insertItems(at: [IndexPath(row: self.movies.count - 1, section: 0)])
                        }
                    }
                case .failure(let error):
                    
                    if self.movieDiscoverFilter.pageNumber > 1 {
                        
                        self.movieDiscoverFilter.pageNumber -= 1
                    }
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
        
        let vc = FilterViewController(filter: movieDiscoverFilter)
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func showSort() {
        
    }
}


extension MainViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        present(MovieDetailViewController(movie: self.movies[indexPath.row]), animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        
        if (elementKind == UICollectionView.elementKindSectionFooter) {
            
            if !self.moviesCollectionView.refreshControl!.isRefreshing {
                self.fetchActivityIindicator.startAnimating()
                
                
                self.discoverMovies()
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionView.elementKindSectionFooter) {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footerCell", for: indexPath)
            
            footerView.addSubview(fetchActivityIindicator)
            fetchActivityIindicator.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
            fetchActivityIindicator.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
            return footerView
            
        }
        
        fatalError()
    }
    
}

extension MainViewController : UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            
            self.movies[indexPath.row].getThumnailImage(completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        
        if self.movies[indexPath.row].thumbailImage == nil {
            
            cell.activityIindicator.startAnimating()
            self.movies[indexPath.row].getThumnailImage {
                
                self.setThumbnailToCell(cell: cell, indexPath: indexPath)
            }
        } else {
            
            setThumbnailToCell(cell: cell, indexPath: indexPath)
        }
        
        return cell
    }
    
    func setThumbnailToCell(cell : MovieCollectionViewCell, indexPath: IndexPath) {
        
        cell.movieImageView.image = self.movies[indexPath.row].thumbailImage
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

extension MainViewController : FilterViewControllerDelegate {
    
    func filterApplied(filter: MovieDiscoverFilter) {
        
        self.movieDiscoverFilter.pageNumber = 0
        self.movies.removeAll()
        self.moviesCollectionView.reloadData()
    }
}
