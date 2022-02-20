//
//  ImageProvider.swift
//  CityListDemo
//
//  Created by ChungTing on 2022/2/13.
//

import Foundation
import UIKit
import Promises
import CoreData

class ImageProvider: ImageFechable, CoreDataFetchable {

    var session = URLSession.shared

    func getImage(urlString: String, name: String) -> Promise<UIImage> {
        let promise = Promise<UIImage>.pending()
        fetchImage(urlString: urlString, name: name)
            .then { [weak self] image in
                if let self = self, let data = image.pngData() {
                    self.catchImage(key: name, data: data)
                }
                promise.fulfill(image)
            }.catch { [weak self] error in
                print("An error \(error) occure whan fetching the image: \(urlString) with name: \(name)")
                promise.fulfill(self?.getFallbackImage(key: name) ?? UIImage())
            }
        return promise
    }
    
    private func getFallbackImage(key: String) -> UIImage {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageData")
        request.predicate = NSPredicate(format: "name == %@", key)
        guard let imageData = getCachedElement(by: request) as? ImageData,
              let rawData = imageData.data,
              let image = UIImage(data: rawData) else {
            return UIImage()
        }
        return image
    }
    
    private func catchImage(key: String, data: Data) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageData")
        request.predicate = NSPredicate(format: "name == %@", key)
        if let imageData = getCachedElement(by: request) as? ImageData {
            imageData.data = data
            save()
        } else {
            let newImageData = ImageData(context: CoreDataManager.shared.mainContext)
            newImageData.name = key
            newImageData.data = data
            save()
        }
    }
}
