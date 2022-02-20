//
//  CityListViewModel.swift
//  CityListDemo
//
//  Created by ChungTing on 2022/2/9.
//

import Foundation
import UIKit
import Combine

class CityListViewModel {

    private let serviceProviders: [APIServiceProvider] = [CityListServiceProvider(), FoodListServiceProvider()]

    var cellModelPublishers: [AnyPublisher<[ListItemCellModel], Never>] {
        return serviceProviders.compactMap { ($0 as? ListCellModelProvider)?.cellModelPublisher }
    }

    func fetchAll() {
        serviceProviders.forEach { $0.fetch() }
    }
}

extension CityListViewModel {

    var cellsInfo: [CellInfo] {
        return serviceProviders.compactMap { provider in
            guard let cellInfo = (provider as? ListCellInfoProvider)?.cellInfo else {
                return nil
            }
            return cellInfo
        }
    }

    var sectionsCount: Int {
        return serviceProviders.count
    }

    func getSectionTitle(index: Int) -> String? {
        guard index < serviceProviders.count,
            let provide = serviceProviders[index] as? ListCellModelProvider else {
            return nil
        }
        return provide.name
    }

    func getSectionCellIndentifier(index: Int) -> String? {
        guard index < serviceProviders.count,
            let provider = serviceProviders[index] as? ListCellInfoProvider else {
            return nil
        }
        return provider.cellInfo.identifier
    }

    func update(_ cell: UITableViewCell, with cellModel: ListItemCellModel, index: IndexPath) {
        if let cell = cell as? CityTableViewCell {
            cell.cellModel = cellModel
            //cell.update(model: cellModel, index: index)
        } else if let cell = cell as? FoodTableViewCell {
            //cell.update(model: cellModel, index: index)
            cell.cellModel = cellModel
        }
    }
}
