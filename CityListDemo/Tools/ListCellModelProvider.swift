//
//  ListCellModelProvider.swift
//  CityListDemo
//
//  Created by ChungTing on 2022/2/20.
//

import Foundation
import Combine

protocol ListCellModelProvider {
    var name: String {get}
    var cellModelPublisher: AnyPublisher<[ListItemCellModel], Never> { get }
}

extension CityListServiceProvider: ListCellModelProvider {
    var name: String {
        return "Main Cities in Japan"
    }
    var cellModelPublisher: AnyPublisher<[ListItemCellModel], Never> {
        return self
            .cityModelPublisher
            .map { $0.map { $0 as ListItemCellModel } }
            .eraseToAnyPublisher()
    }
}

extension FoodListServiceProvider: ListCellModelProvider {
    var name: String {
        return "Main Popular Japanese Food"
    }
    var cellModelPublisher: AnyPublisher<[ListItemCellModel], Never> {
        return self
            .foodModelPublisher
            .map { $0.map { $0 as ListItemCellModel } }
            .eraseToAnyPublisher()
    }
}
