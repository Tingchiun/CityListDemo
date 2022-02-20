//
//  APIServiceProvider.swift
//  CityListDemo
//
//  Created by ChungTing on 2022/2/16.
//

import Foundation
import Promises
import Combine

enum ServiceError: Error {
    case invalidURL
    case fetchError
    case decodeError
}

protocol APIServiceProvider {
    var session: URLSession {get}
    func fetch()
}

extension APIServiceProvider {
    func fetchData<T: Decodable>(urlString: String) -> Promise<[T]> {
        guard let url = URL(string: urlString) else { return Promise(ServiceError.invalidURL) }
        let promise = Promise<[T]>.pending()
        session.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data else {
                promise.reject(ServiceError.fetchError)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                promise.reject(ServiceError.fetchError)
                return
            }
            do {
                let elements = try JSONDecoder().decode([T].self, from: data)
                promise.fulfill(elements)
            } catch {
                promise.reject(ServiceError.decodeError)
                return
            }
        }.resume()
        return promise
    }
}
