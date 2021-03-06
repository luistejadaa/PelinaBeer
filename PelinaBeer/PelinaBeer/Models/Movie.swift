//
//  Movie.swift
//  PelinaBeer
//
//  Created by Intellisys on 8/13/20.
//  Copyright © 2020 Luis Tejada. All rights reserved.
//

import Foundation
import UIKit.UIImage
import FirebaseFirestore

class Movie : NSObject, Codable {
    
    let popularity: Double!
    let vote_count: Int!
    let video: Bool!
    let poster_path: String!
    let id: Int!
    let adult: Bool!
    let backdrop_path: String!
    let original_language: String!
    let original_title: String!
    let genre_ids: [Int]!
    let title: String!
    let vote_average: Double!
    let overview: String!
    let release_date: String!
    
    var thumbailImage : UIImage?
    var fullSizeImage : UIImage?
    var isFavorite : Bool = false
    
    override var description: String {title}
    
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
    
    let thumbnailImageSize = "w200"
    let fullImageSize = "w500"
    
    static var favoriteMovies : [Movie]?
    
    
    static func getAllFavorites(completion: @escaping (Bool) -> Void) {
        
        let db = Firestore.firestore()
        let decoder = JSONDecoder()
        
        db.collection("Favs").getDocuments { (snapshot, error) in
            
            if error == nil {
                
                if Movie.favoriteMovies == nil {Movie.favoriteMovies = [Movie]()}
                Movie.favoriteMovies?.removeAll()
                for d in snapshot!.documents {
                    let data = try! JSONSerialization.data(withJSONObject: d.data(), options: .prettyPrinted)
                    let m = try! decoder.decode(Self.self, from: data)
                    
                    if Movie.favoriteMovies?.first(where: {$0.id == m.id}) == nil {
                        
                        m.isFavorite = true
                        Movie.favoriteMovies?.append(m)
                    }
                }
                
                completion(true)
            } else {
                
                completion(false)
            }
        }
    }
    
    func addToFavorite(completion: @escaping (Bool) -> Void) {
        
        let db = Firestore.firestore()
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        guard let data = try? encoder.encode(self) else {completion(false); return}
        guard let dic = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject] else {completion(false); return}
        db.collection("Favs").document(id.description).setData(dic) { (error) in
            
            if error == nil {
                
                Movie.favoriteMovies?.append(self)
                completion(true)
                
            } else {
                
                completion(false)
            }
        }
    }
    
    func removeFromFavorite(completion: @escaping (Bool) -> Void) {
        
        let db = Firestore.firestore()
        db.collection("Favs").document(id.description).delete { (error) in
            
            if error == nil {
                
                Movie.favoriteMovies?.removeAll {$0.id == self.id}
                completion(true)
                
            } else {
                
                completion(false)
            }
        }
    }
    
    func getThumnailImage(completion: (() -> Void)?) {
        
        
        if let poster_path = poster_path {
            
            getImage(path: "\(thumbnailImageSize)/\(poster_path)") { image in
                
                self.thumbailImage = image
                completion?()
            }
        }
    }
    
    func getFullSizeImage(completion: (() -> Void)?) {
        
        if let backdrop_path = backdrop_path {
            
            getImage(path: "\(fullImageSize)/\(backdrop_path)") { image in
                
                self.fullSizeImage = image
                completion?()
                
            }
        }
    }
    
    fileprivate func getImage(path: String, completion: @escaping ((UIImage) -> Void)) {
        
        API.shared.getImage(imagePath: path) { (image) in
            
            completion(image)
        }
    }
    
    static func discoverMovies(filter: MovieDiscoverFilter, completion: @escaping (Result<APIResponse<Movie>, Error>) -> Void) {
        
        var query = [URLQueryItem]()
        
        query.append(URLQueryItem(name: "page", value: filter.pageNumber.description))
        query.append(URLQueryItem(name: "sort_by", value: filter.sort_by.val))
        
        if let rating = filter.rating {
            
            query.append(URLQueryItem(name: "vote_average.gte", value: rating.description))
        }
        if let genres = filter.getGenresId() {
            
            query.append(URLQueryItem(name: "with_genres", value: genres))
        }
        if let year = filter.year {
            
            query.append(URLQueryItem(name: "year", value: year.description))
        }
        
        API.shared.getWithPagination(path: "discover/movie", queryItems: query) { (response: Result<APIResponse<Movie>, Error>) in
            
            switch response {
                
            case .success(let movies):
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
