//
//  APIClient.swift
//  Trooper-currency-converter
//
//  Created by Md Refat Hossain on 15/06/2025.
//

import Foundation
import RxSwift

class APIClient {
    private let baseURL = URL(string: "")! // TODO: need to change
    private var urlSession: URLSession
    private lazy var jsonDecoder = JSONDecoder()
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    func send<T: Codable>(apiRequest: APIRequest) -> Observable<T> {
        let request = apiRequest.request(with: baseURL)
        
        return Observable.create { observer in
            
            let task = self.urlSession.dataTask(with: request) { (data,
                                                                  response, error) in
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    do {
                        let _data = data ?? Data()
                        if (200...399).contains(statusCode) {
                            let objs = try self.jsonDecoder.decode(T.self, from: _data)
                            observer.onNext(objs)
                        }
                        else {
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
}
