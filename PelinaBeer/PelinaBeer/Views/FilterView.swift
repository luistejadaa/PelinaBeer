//
//  FilterView.swift
//  PelinaBeer
//
//  Created by Intellisys on 8/13/20.
//  Copyright © 2020 Luis Tejada. All rights reserved.
//

import UIKit

class FilterView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    let titleLabel: UILabel = {
        let l = UILabel(frame: .zero)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Filtro"
        return l
    }()
    
    let filterOptionstableView: UITableView = {
        let t = UITableView(frame: .zero, style: .plain)
        t.register(UITableViewCell.self, forCellReuseIdentifier: "optionCell")
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        
        center = newSuperview!.center
    }
    
    func setupView() {
     
        backgroundColor = .white
        layer.cornerRadius = 10
        addSimpleShadow()
        
        
    }
    
    func show() {
        
        if let superView = superview {
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 15, options: .curveEaseIn, animations: {
                
                self.frame.size = CGSize(width: superView.frame.width / 1.7, height: superView.frame.width)
                self.center = superView.center
                
            }, completion: nil)
        }
    }
    
    func hide() {
        
    }
}
