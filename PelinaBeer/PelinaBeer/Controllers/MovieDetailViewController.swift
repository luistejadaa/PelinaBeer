//
//  MovieDetailViewController.swift
//  PelinaBeer
//
//  Created by Intellisys on 8/13/20.
//  Copyright © 2020 Luis Tejada. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    
    let movie : Movie!
    var data : [(description: String, data: String)]!
    
    let detailTableView : UITableView = {
       
        let t = UITableView(frame: .zero, style: .plain)
        t.translatesAutoresizingMaskIntoConstraints = false
        t.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "detailCell")
        t.tableFooterView = UIView(frame: .zero)
        t.allowsSelection = false
        return t
    }()
    
    let imageViewContainer : UIView = {
       
        let v = UIView(frame: .zero)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.1026628521)
        return v
    }()
    
    let activityIindicator: UIActivityIndicatorView = {
        let a = UIActivityIndicatorView(style: .medium)
        a.translatesAutoresizingMaskIntoConstraints = false
        a.color = .mainColor
        return a
    }()
    
    let movieImageView: UIImageView = {
        
        let i = UIImageView(frame: .zero)
        i.translatesAutoresizingMaskIntoConstraints = false
        i.contentMode = .scaleToFill
        return i
    }()
    
    let tittleLabel : UILabel = {
        
        let l = UILabel(frame: .zero)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    
    init(movie: Movie) {
        
        self.movie = movie
        data = [("Title", movie.title), ("Overview", movie.overview), ("Qualification", movie.vote_average.description), ("Popularity", String(format: "%.2f", movie.popularity!))]
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        detailTableView.dataSource = self
        
        view.backgroundColor = .white
        view.addSubview(imageViewContainer)
        view.addSubview(detailTableView)
        imageViewContainer.addSubview(movieImageView)
        imageViewContainer.addSubview(activityIindicator)
        
        imageViewContainer.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        imageViewContainer.heightAnchor.constraint(equalToConstant: view.frame.height / 2.5).isActive = true
        imageViewContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageViewContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        movieImageView.widthAnchor.constraint(equalTo: imageViewContainer.widthAnchor).isActive = true
        movieImageView.heightAnchor.constraint(equalTo: imageViewContainer.heightAnchor).isActive = true
        movieImageView.centerXAnchor.constraint(equalTo: imageViewContainer.centerXAnchor).isActive = true
        movieImageView.topAnchor.constraint(equalTo: imageViewContainer.topAnchor).isActive = true
        
        activityIindicator.centerXAnchor.constraint(equalTo: imageViewContainer.centerXAnchor).isActive = true
        activityIindicator.centerYAnchor.constraint(equalTo: imageViewContainer.centerYAnchor).isActive = true
        
        detailTableView.topAnchor.constraint(equalTo: imageViewContainer.bottomAnchor).isActive = true
        detailTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        detailTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        detailTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.activityIindicator.startAnimating()
        movie.getFullSizeImage {
            
            self.movieImageView.image = self.movie.fullSizeImage
            DispatchQueue.main.async {
                
                self.activityIindicator.stopAnimating()
            }
        }
    }
}

extension MovieDetailViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! SubtitleTableViewCell
        cell.textLabel?.textColor = UIColor(named: "mainColor")
        cell.textLabel?.text = data[indexPath.row].description
        cell.detailTextLabel?.text = data[indexPath.row].data
        cell.detailTextLabel?.numberOfLines = 0
        return cell
    }
    
}
