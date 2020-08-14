//
//  UIView.swift
//  PelinaBeer
//
//  Created by Intellisys on 8/14/20.
//  Copyright © 2020 Luis Tejada. All rights reserved.
//

import UIKit.UIView

extension UIView {
    
    func addSimpleShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 1
        layer.shadowOffset = CGSize(width: 1, height: 2)
        layer.shadowOpacity = 0.2
    }
}
