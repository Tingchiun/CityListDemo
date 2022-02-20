//
//  FoodDataModel.swift
//  CityListDemo
//
//  Created by ChungTing on 2022/2/17.
//

import Foundation

struct FoodDataModel: Codable {
    let name: String
    let image: String
    
    init(food: FoodData) {
        self.name = food.name ?? ""
        self.image = food.imageURLString ?? ""
    }

    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}

extension FoodDataModel: ListItemCellModel {
    var cellName: String {
        return self.name
    }
    var cellImage: String {
        return self.image
    }
    var cellDetail: String? {
        return nil
    }
}
