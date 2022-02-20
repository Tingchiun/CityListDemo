//
//  FoodListServiceProvider.swift
//  CityListDemo
//
//  Created by ChungTing on 2022/2/17.
//

import Foundation
import Combine
import Promises
import CoreData

class FoodListServiceProvider: APIServiceProvider, CoreDataFetchable {
    
    static let endpoint = "https://api.npoint.io/b4dd0d44343f7eb08f9c"
    static let entityName = "FoodData"
    
    let foodModelPublisher = PassthroughSubject<[FoodDataModel], Never>()
    var session = URLSession.shared

    var fallbackFoodList: [FoodDataModel] {
        guard let foodData = getAllFromCache(entity: FoodData.self) as? [FoodData] else {
            return []
        }
        return foodData.map { FoodDataModel(food: $0) }
    }
    
    func cacheFoodList(foodModel: FoodDataModel) {
        let newFoodData =  FoodData(context: CoreDataManager.shared.mainContext)
        newFoodData.imageURLString = foodModel.image
        newFoodData.name = foodModel.name
    }
    
    func fetch() {
        let promise: Promise<[FoodDataModel]> = fetchData(urlString: FoodListServiceProvider.endpoint)
        promise.then { food in
            do {
                try self.clear()
            } catch {
                print("An error: \(error.localizedDescription) occurred when cleanning the food list cache")
            }
            food.forEach { self.cacheFoodList(foodModel: $0) }
            self.foodModelPublisher.send(food)
        }.catch { [weak self] error in
            print("An error: \(error.localizedDescription) occurred when fetching the food list")
            guard let self = self else { return }
            self.foodModelPublisher.send(self.fallbackFoodList)
        }
    }

    func clear() throws {
        try clear(entityName: FoodListServiceProvider.entityName)
    }
}
