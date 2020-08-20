//
//  FavoritesViewController.swift
//  PelinaBeer
//
//  Created by Intellisys on 8/13/20.
//  Copyright © 2020 Luis Tejada. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    
    var moviesFiltered : [Movie]?
    var filter : MovieDiscoverFilter!
    var favsIsLoading : Bool!
    
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
        
        filter = MovieDiscoverFilter(pageNumber: 0, rating: 0, year: nil, genres: nil, sortBy: Sort.sorts["popularity"]!)
        view.backgroundColor = .white
        favsIsLoading = false
        
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
        
        if Movie.favoriteMovies == nil {
            
            self.fetchActivityIindicator.startAnimating()
            Movie.getAllFavorites { (isCompleted) in
                
                self.fetchActivityIindicator.stopAnimating()
                self.favsIsLoading = isCompleted
                self.moviesFiltered = Movie.favoriteMovies
                self.moviesCollectionView.reloadData()
                
            }
        } else {
            
            self.moviesFiltered = Movie.favoriteMovies
            self.moviesCollectionView.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func refreshdData() {
        
        
        DispatchQueue.main.async {
            
            if self.moviesCollectionView.refreshControl!.isRefreshing {
                self.moviesCollectionView.reloadData()
            }
        }
        
        Movie.getAllFavorites { (isCompleted) in
            
            self.moviesCollectionView.refreshControl?.endRefreshing()
            self.favsIsLoading = isCompleted
            self.moviesFiltered = Movie.favoriteMovies
            self.moviesCollectionView.reloadData()
        }
    }
    
    @objc func showFilter() {
        
        let vc = FilterViewController(filter: filter)
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func showSort() {
        
    }
}


extension FavoritesViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = MovieDetailViewController(movie: self.moviesFiltered![indexPath.row])
        vc.dismissMovie = { movie in self.dismissMovie(movie: movie)}
        present(vc, animated: true, completion: nil)
    }
    
    func dismissMovie(movie: Movie) -> Void {
        
        self.moviesCollectionView.reloadData()
    }
}

extension FavoritesViewController : UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        moviesFiltered?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            
            moviesFiltered![indexPath.row].getThumnailImage(completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        
        cell.favButton.tag = indexPath.row
        cell.delegate = self
        
        if self.moviesFiltered![indexPath.row].thumbailImage == nil {
            
            cell.activityIindicator.startAnimating()
            self.moviesFiltered![indexPath.row].getThumnailImage {
                
                self.setThumbnailToCell(cell: cell, indexPath: indexPath)
            }
        } else {
            
            setThumbnailToCell(cell: cell, indexPath: indexPath)
        }
        
        cell.favButton.tintColor = moviesFiltered![indexPath.row].isFavorite ? .red : .lightGray
        return cell
    }
    
    func setThumbnailToCell(cell : MovieCollectionViewCell, indexPath: IndexPath) {
        
        cell.movieImageView.image = self.moviesFiltered![indexPath.row].thumbailImage
    }
}

extension FavoritesViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = view.frame.width / 2
        return CGSize(width: size - 20, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 8, left: 13, bottom: 8, right: 13)
    }
}

extension FavoritesViewController : MovieCollectionViewCellDelegate {
    
    func favButtonTouched(row: Int) {
        
        let cell = self.moviesCollectionView.cellForItem(at: IndexPath(row: row, section: 0)) as! MovieCollectionViewCell
        cell.activityIindicator.startAnimating()
        
        
        moviesFiltered![row].removeFromFavorite { (isRemoved) in
            
            cell.activityIindicator.stopAnimating()
            
            if isRemoved {
                
                self.moviesCollectionView.deleteItems(at: [IndexPath(row: row, section: 0)])
            }
        }
    }
}

extension FavoritesViewController : FilterViewControllerDelegate {
    
    func filterApplied(filter: MovieDiscoverFilter) {
        
        
        applyFilter()
    }
    
    func applyFilter() {
        
        self.moviesFiltered = Movie.favoriteMovies?.filter({ (movie) -> Bool in

            var pass = [Bool]()
            if let genres = filter.genres {

                pass.append(movie.genre_ids.contains {id in genres.contains { (genre) -> Bool in id == genre.id}})
            }

            if let year = filter.year {

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date = dateFormatter.date(from: movie.release_date)!
                pass.append(Calendar.current.component(.year, from: date) >= year)
            }

            pass.append(movie.vote_average >= filter.rating)

            return !pass.contains(false)
        })
        
        for m in self.moviesFiltered! {
            
            print(m.description)
        }
        self.moviesFiltered?.sort(by: { (m1, m2) -> Bool in
            
            switch filter.sort_by.description {
                
            case "Name":
                return m1.title < m2.title
            case "Popularity":
                return m1.vote_average > m2.vote_average
            case "Year":
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date1 = dateFormatter.date(from: m1.release_date)!
                let date2 = dateFormatter.date(from: m1.release_date)!
                let year1 = Calendar.current.component(.year, from: date1)
                let year2 = Calendar.current.component(.year, from: date2)
                return year1 > year2
                default: return true
            }
        })
        
        print("\n\n")
        for m in self.moviesFiltered! {
            
            print(m.description)
        }
        
        DispatchQueue.main.async {
            self.moviesCollectionView.reloadData()
        }
    }
}

