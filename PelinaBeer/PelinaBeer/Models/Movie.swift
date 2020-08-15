//
//  Movie.swift
//  PelinaBeer
//
//  Created by Intellisys on 8/13/20.
//  Copyright © 2020 Luis Tejada. All rights reserved.
//

import Foundation
import UIKit.UIImage

class Movie : Codable {
    
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
        
    var thumbailImage : UIImage?
    
    private enum CodingKeys : String, CodingKey {
        
        case popularity
        case vote_count
        case video
        case poster_path
        case id
        case adult
        case backdrop_path
        case original_language
        case original_title
        case genre_ids
        case title
        case vote_average
        case overview
        case release_date
    }
    
    func getThumnailImage(completion: @escaping () -> Void) {
        
        if let poster_path = poster_path {
            
            API.shared.getImage(imagePath: "w300/\(poster_path)") { (image) in
                
                self.thumbailImage = image
                completion()
            }
        }
    }
    
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
