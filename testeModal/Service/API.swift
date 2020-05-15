//
//  API.swift
//  testeModal
//
//  Created by Fernanda de Lima on 14/05/20.
//  Copyright © 2020 felima. All rights reserved.
//

import Foundation
import RxSwift


enum Endpoint {
    case repository(String,String, Int)
    func pathEndpoint() -> String {
        switch self {
        case .repository(let language, let sort, let page):return "language:\(language)&sort=\(sort)&page=\(page)"
        }
    }
}

class API {
    static var page = 1
    static let baseUrl = "https://api.github.com/search/repositories?q="
    
    static func get <T: Any>
        (_ type: T.Type,
         endpoint: Endpoint) -> Observable<T> where T: Decodable  {
        return Observable.create { observer -> Disposable in
        
            let url = "\(baseUrl)\(endpoint.pathEndpoint())"
            print("===>url: \(url)")
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            //create session to connection
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                do {
                    //verify response
                    if let httpResponse = response as? HTTPURLResponse {
                        print("===>code response: \(httpResponse.statusCode)")
                        if httpResponse.statusCode == 200 { //it's ok
                            //verify if have response data
                            if let data = data {
                                let jsonDecoder = JSONDecoder()
                                let jsonArray = try jsonDecoder.decode(type.self, from: data)
                                observer.onNext(jsonArray)
                            }
                        }
                    }
                } catch (let error){
                    observer.onError(error)
                }
            })
            task.resume()
            
            return Disposables.create()
        }
    }
}
