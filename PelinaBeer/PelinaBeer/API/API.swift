//
//  API.swift
//  PelinaBeer
//
//  Created by Intellisys on 8/14/20.
//  Copyright © 2020 Luis Tejada. All rights reserved.
//

import UIKit.UIImage
import Alamofire
import AlamofireImage

class API {
    
    static let shared : API = {
       
        let instance = API()
        return instance
    }()
    
    let imageURL = "https://image.tmdb.org/t/p/"
    
    let scheme = "https"
    let base = "api.themoviedb.org"
    let apiVersion = "3"
    let apiKey = "08a0fc148890c69deeaffefbbffe3b5e"
    
    var urlComponents : URLComponents!
    
    fileprivate init() {
        
        urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = base
    }
    
    func get<T>(path: String, queryItems : [URLQueryItem], completion: @escaping (Result<APIResponse<T>, Error>) -> Void) where T : Codable {
            
                print(path)
        
        urlComponents.queryItems = queryItems
        urlComponents.path = "/\(apiVersion)/\(path)"
        urlComponents.queryItems?.append(URLQueryItem(name: "api_key", value: apiKey))
        AF.request(urlComponents.url!, method: .get) { urlRequest in

            urlRequest.timeoutInterval = 30
        }
        .validate(statusCode: 200...300)
        .validate(contentType: ["application/json"])
        .responseDecodable(of: APIResponse<T>.self) { response in
        
            if let error = response.error {
                
                print("Error")
                completion(.failure(error))
                
            } else {
             
                if(response.value == nil) {
                    
                    completion(.failure(NSError(domain: "Value is empty", code: -1, userInfo: nil)))
                }
                else {
                    
                    completion(.success(response.value!))
                }
            }
        }
    }
    
    func getImage(imagePath : String, completion: @escaping (UIImage) -> Void) {
        
        AF.request("\(imageURL)\(imagePath)", method: .get).responseImage { (response) in
            completion(response.value ?? UIImage(named: "imageNotFound")!)
        }
    }
}
