//
//  MovieCollectionViewCell.swift
//  PelinaBeer
//
//  Created by Intellisys on 8/14/20.
//  Copyright © 2020 Luis Tejada. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    
    
    var delegate : MovieCollectionViewCellDelegate?
    
    @objc dynamic var movieImageView: UIImageView = {
        let i = UIImageView(frame: .zero)
        i.translatesAutoresizingMaskIntoConstraints = false
        i.contentMode = .scaleAspectFill
        i.layer.cornerRadius = 8
        i.clipsToBounds = true
        return i
    }()
    
    let activityIindicator: UIActivityIndicatorView = {
        let a = UIActivityIndicatorView(style: .medium)
        a.translatesAutoresizingMaskIntoConstraints = false
        a.color = .mainColor
        return a
    }()
    
    
    let favButton : UIButton = {
       
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(named: "fav_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        b.tintColor = .gray
        return b
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup() {
        
        backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.1026628521)
        layer.cornerRadius = 8
        addSimpleShadow()
        
        addSubview(movieImageView)
        addSubview(activityIindicator)
        addSubview(favButton)
        favButton.addTarget(self, action: #selector(favButtonTouched), for: .touchUpInside)
        
        movieImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        movieImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        movieImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        movieImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        
        activityIindicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIindicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        favButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        favButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        
        movieImageView.addObserver(self, forKeyPath: "image", options: .new, context: nil)
        
    }
    
    @objc func favButtonTouched(_ sender : UIButton) {
        
        delegate?.favButtonTouched(row: Int(sender.tag))
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        activityIindicator.stopAnimating()
    }
}


protocol MovieCollectionViewCellDelegate {
    
    func favButtonTouched(row: Int)
}
extension MovieCollectionViewCellDelegate {
    
    func favButtonTouched(row: Int) {
        
    }
}
