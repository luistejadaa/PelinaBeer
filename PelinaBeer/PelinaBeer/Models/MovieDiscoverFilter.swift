//
//  SearchFilter.swift
//  PelinaBeer
//
//  Created by Intellisys on 8/18/20.
//  Copyright © 2020 Luis Tejada. All rights reserved.
//

import Foundation

struct MovieDiscoverFilter {
    
    var pageNumber : Int!
    var rating : Double?
    var year : Int?
    var genres : [Int]?
    
    func getGenresId() -> String? {
        
        if let genres = self.genres {
            
            var str = ""
            for s in genres {
                
                str.append(contentsOf: "\(s),")
            }
            
            if str.count >= 2 {
                
                str.remove(at: str.endIndex)
            }
             
            return str
        }
        
        return nil
    }
}
