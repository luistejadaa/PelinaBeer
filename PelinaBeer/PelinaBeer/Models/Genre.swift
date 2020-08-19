//
//  Genre.swift
//  PelinaBeer
//
//  Created by Intellisys on 8/18/20.
//  Copyright © 2020 Luis Tejada. All rights reserved.
//

import Foundation

class Genre : Codable {
    
    
    var id : Int!
    var name: String!
    
    static func getGenres(completion: @escaping ([Genre]?) -> Void) {
        
        API.shared.getWithoutPagination(path: "genre/movie/list", queryItems: []) { (response : Result<GenreResponse, Error>) in
            
            switch response {
                
            case .success(let rm):
                completion(rm.genres)
            case .failure(_):
                completion(nil)
            }
        }
    }
 }

struct GenreResponse : Codable {
    
    var genres : [Genre]!
}
