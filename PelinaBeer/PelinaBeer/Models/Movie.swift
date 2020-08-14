//
//  Movie.swift
//  PelinaBeer
//
//  Created by Intellisys on 8/13/20.
//  Copyright © 2020 Luis Tejada. All rights reserved.
//

import Foundation


struct Movie : Codable {
    
    let name : String!
    let synopsis : String!
    let imageURL : String!
    let calification : Double!
    let publishDate : Double!
    
    static func discoverMovies(completion: @escaping ([Movie]) -> Void) {
        
        API.shared.get(path: "discovery", queryItems: []) { (response: Result<[Movie], Error>) in
            
        }
    }
}
