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
    
    
    
    let movieImageView: UIImageView = {
        
        let i = UIImageView(frame: .zero)
        i.translatesAutoresizingMaskIntoConstraints = false
        i.backgroundColor = .red
        i.contentMode = .scaleAspectFit
        return i
    }()
    
    let tittleLabel : UILabel = {
       
        let l = UILabel(frame: .zero)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    
    init(movie: Movie) {
        
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        view.addSubview(movieImageView)
        
        movieImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        movieImageView.heightAnchor.constraint(equalToConstant: view.frame.height / 2.5).isActive = true
        movieImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        movieImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
