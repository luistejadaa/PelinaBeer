//
//  User.swift
//  PelinaBeer
//
//  Created by Intellisys on 8/13/20.
//  Copyright © 2020 Luis Tejada. All rights reserved.
//

import Foundation


class User : NSObject {
    
    override var description: String {return "Demo"}
    
    static let shared : User = {
        
        let instance = User()
        return instance
    }()
    
    func AddToFavorite(movie : Movie) {
        
    }
}
