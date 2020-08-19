//
//  GenresTableViewController.swift
//  PelinaBeer
//
//  Created by Intellisys on 8/18/20.
//  Copyright © 2020 Luis Tejada. All rights reserved.
//

import UIKit

class GenresTableViewController: UITableViewController {
    
    
    var genres : [Genre]?
    var delegate : GenresTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "genreCell")
        tableView.allowsMultipleSelection = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(done))
        navigationController?.navigationBar.tintColor = .mainColor
        
        Genre.getGenres { (genres) in
            
            if let genres = genres {
                
                self.genres = genres
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func done() {
        
        if let delegate = self.delegate {
            
            if let indexPaths = self.tableView.indexPathsForSelectedRows, let genres = self.genres {
                
                var selectedGenres = [Genre]()
                for i in indexPaths {
                    
                    selectedGenres.append(genres[i.row])
                }
                delegate.genresTableSelected(genres: selectedGenres)
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return genres?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genreCell", for: indexPath)
        
        cell.textLabel?.text = self.genres?[indexPath.row].name
        cell.textLabel?.textColor = .darkText
        return cell
    }

}

protocol GenresTableViewDelegate {
    
    func genresTableSelected(genres: [Genre])
}

extension GenresTableViewDelegate {
    
    func genresTableSelected(genres: [Genre]) {
        
    }
}
