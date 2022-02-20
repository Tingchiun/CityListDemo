//
//  CityListServiceProvider.swift
//  CityListDemo
//
//  Created by ChungTing on 2022/2/17.
//

import Foundation
import Combine
import Promises
import CoreData

class CityListServiceProvider: APIServiceProvider, CoreDataFetchable {
    
    static let endpoint = "https://api.npoint.io/e81570e822b273f0a366"
    static let entityName = "CityData"
    
    let cityModelPublisher = PassthroughSubject<[CityDataModel], Never>()
    var session = URLSession.shared
    
    var fallbackCityList: [CityDataModel] {
        guard let cityData = getAllFromCache(entity: CityData.self) as? [CityData] else {
            return []
        }
        return cityData.map { CityDataModel(city: $0) }
    }
    
    func cacheCityList(cityModel: CityDataModel) {
        let newCityData = CityData(context: CoreDataManager.shared.mainContext)
        newCityData.imageURLString = cityModel.image
        newCityData.name = cityModel.name
        newCityData.descrip = cityModel.description
    }
    
    func fetch() {
        let promise: Promise<[CityDataModel]> = fetchData(urlString: CityListServiceProvider.endpoint)
        promise.then { cities in
            do {
                try self.clear()
            } catch {
                print("An error: \(error.localizedDescription) occurred when cleanning the food list cache")
            }
            cities.forEach { self.cacheCityList(cityModel: $0) }
            self.cityModelPublisher.send(cities)
        }.catch { [weak self] error in
            print("An error: \(error.localizedDescription) occurred when fetching the city list")
            guard let self = self else { return }
            self.cityModelPublisher.send(self.fallbackCityList)
        }
    }

    func clear() throws {
        try clear(entityName: CityListServiceProvider.entityName)
    }
}
