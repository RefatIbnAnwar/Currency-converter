//
//  NetworkService.swift
//  Trooper-currency-converter
//
//  Created by Md Refat Hossain on 15/06/2025.
//

import Foundation
import RxSwift


protocol NetworkServiceProtocol {
    func performRequest<T : Codable>(endpoint: APIEndpoint, responseType: T.Type) -> Observable<T>
}

struct NetworkService : NetworkServiceProtocol {
    
    private let session : URLSession
        
    init(session: URLSession = .shared) {
            self.session = session
    }
    
    func performRequest<T: Decodable>(endpoint: APIEndpoint, responseType: T.Type) -> Observable<T> {
        guard let request = createURLRequest(endpoint: endpoint) else {
            fatalError("Unable to create URL Request")
        }
        
        return Observable.create { observer in
            let task = self.session.dataTask(with: request) { data ,response,error in
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    do {
                        let _data = data ?? Data()
                        if (200...399).contains(statusCode) {
                            let objs =  try JSONDecoder().decode(T.self, from: _data)
                            observer.onNext(objs)
                        }
                        else {
                            print(statusCode)
                            observer.onError(error!)
                        }
                    } catch {
                        observer.onError(error)
                    }
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    private func createURLRequest(endpoint: APIEndpoint) -> URLRequest? {
            guard var components = URLComponents(string: endpoint.path) else {
                return nil
            }
            
            if let parameters = endpoint.queryParameters  {
                components.queryItems = parameters.map({ (key: String, value: String) in
                    URLQueryItem(name: key, value: value)
                })
            }
            
            guard let url = components.url else {
                return nil
            }
            var request = URLRequest(url: url)
            request.httpMethod = endpoint.method.rawValue
            request.allHTTPHeaderFields = endpoint.headers
            
            if let body = endpoint.body {
                request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            }
            
            return request
        }
}
