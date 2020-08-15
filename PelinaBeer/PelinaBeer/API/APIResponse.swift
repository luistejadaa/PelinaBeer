//
//  APIResult.swift
//  PelinaBeer
//
//  Created by Intellisys on 8/14/20.
//  Copyright © 2020 Luis Tejada. All rights reserved.
//

import Foundation



class APIResponse<T> : Codable where T : Codable {
    
    var page : Int?
    var total_pages : Int?
    var total_results : Int?
    var results : [T]?
}
