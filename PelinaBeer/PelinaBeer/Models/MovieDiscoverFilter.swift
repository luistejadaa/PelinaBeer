//
//  SearchFilter.swift
//  PelinaBeer
//
//  Created by Intellisys on 8/18/20.
//  Copyright © 2020 Luis Tejada. All rights reserved.
//

import Foundation

class MovieDiscoverFilter {
    
    var pageNumber : Int!
    var rating : Double!
    var year : Int?
    var genres : [Genre]?
    var sort_by : Sort!
    
    
    init(pageNumber: Int, rating: Double?, year: Int?, genres: [Genre]?, sortBy: Sort) {
        self.pageNumber = pageNumber
        self.rating = rating
        self.year = year
        self.genres = genres
        self.sort_by = sortBy
    }
    
    func getGenresId() -> String? {
        
        if let genres = self.genres {
            
            var str = ""
            for g in genres {
                
                str.append(contentsOf: "\(g.id!),")
            }
            
            if str.count >= 2 {
                
                str.removeLast()
            }
            
            return str
        }
        
        return nil
    }
    
    func getGenresNames() -> String? {
        
        if let genres = self.genres {
            
            var str = ""
            for g in genres {
                
                str.append(contentsOf: "\(String(describing: g.name!)),")
            }
            str.removeLast()
            
            return str
        }
        
        return nil
    }
}
