//
//  CityDataModel.swift
//  CityListDemo
//
//  Created by ChungTing on 2022/2/17.
//

import Foundation

struct CityDataModel: Codable {
    let name: String
    let image: String
    let description: String
    
    init(city: CityData) {
        self.name = city.name ?? ""
        self.image = city.imageURLString ?? ""
        self.description = city.descrip ?? ""
    }

    init(name: String, image: String, description: String) {
        self.name = name
        self.image = image
        self.description = description
    }
}

extension CityDataModel: ListItemCellModel {
    var cellName: String {
        return self.name
    }
    var cellImage: String {
        return self.image
    }
    var cellDetail: String? {
        return self.description
    }
}

