//
//  ListCellInfoProvider.swift
//  CityListDemo
//
//  Created by ChungTing on 2022/2/20.
//

import Foundation

struct CellInfo {
    let identifier: String
    let nibName: String
}

protocol ListCellInfoProvider {
    var cellInfo: CellInfo { get }
}

extension FoodListServiceProvider: ListCellInfoProvider {
    var cellInfo: CellInfo {
        return CellInfo(identifier: FoodTableViewCell.identifier, nibName: "FoodTableViewCell")
    }
}

extension CityListServiceProvider: ListCellInfoProvider {
    var cellInfo: CellInfo {
        return CellInfo(identifier: CityTableViewCell.identifier, nibName: "CityTableViewCell")
    }
}
