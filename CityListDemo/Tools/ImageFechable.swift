//
//  ImageFechable.swift
//  CityListDemo
//
//  Created by ChungTing on 2022/2/20.
//

import Foundation
import Promises
import UIKit

public enum ImageError: Error {
    case invalidURL
    case fetchError
    case convertError
}

protocol ImageFechable {
    var session: URLSession { get }
}

extension ImageFechable {
    func fetchImage(urlString: String, name: String) -> Promise<UIImage> {
        guard let url = URL(string: urlString) else { return Promise(ImageError.invalidURL) }
        let promise = Promise<UIImage>.pending()
        session.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data else {
                promise.reject(ImageError.fetchError)
                return
            }
            guard let image = UIImage(data: data) else {
                promise.reject(ImageError.convertError)
                return
            }
            promise.fulfill(image)
        }.resume()
        return promise
    }
}
