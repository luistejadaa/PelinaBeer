//
//  Movie.swift
//  PelinaBeer
//
//  Created by Intellisys on 8/13/20.
//  Copyright © 2020 Luis Tejada. All rights reserved.
//

import Foundation


struct Movie : Codable {
    
        let popularity: Double?
        let vote_count: Int?
        let video: Bool?
        let poster_path: String?
        let id: Int?
        let adult: Bool?
        let backdrop_path: String?
        let original_language: String?
        let original_title: String?
        let genre_ids: [Int]?
        let title: String?
        let vote_average: Double?
        let overview: String?
        let release_date: String?
    
    static func discoverMovies(completion: @escaping (Result<APIResponse<Movie>, Error>) -> Void) {
        
        API.shared.get(path: "discover/movie", queryItems: []) { (response: Result<APIResponse<Movie>, Error>) in
            
            switch response {
                
            case .success(let movies):
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
