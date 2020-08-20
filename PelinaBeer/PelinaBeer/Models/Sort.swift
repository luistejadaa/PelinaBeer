//
//  Sort.swift
//  PelinaBeer
//
//  Created by Intellisys on 8/19/20.
//  Copyright © 2020 Luis Tejada. All rights reserved.
//

import Foundation

struct Sort {
    
    var description : String!
    var val : String!
    static let sorts = [
        
        "name":Sort(description: "Name", val: "original_title.asc"),
        "popularity":Sort(description: "Popularity", val: "popularity.desc"),
        "year":Sort(description: "Year", val: "release_date.desc")
    ]
}
