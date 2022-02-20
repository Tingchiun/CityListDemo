//
//  ListItemCellModel.swift
//  CityListDemo
//
//  Created by ChungTing on 2022/2/20.
//

import Foundation

protocol ListItemCellModel {
    var cellName: String {get}
    var cellImage: String {get}
    var cellDetail: String? {get}
}

extension ListItemCellModel {
    func convertToDetailViewModel() -> DetailViewModel {
        return DetailViewModel(title: self.cellName, imageString: self.cellImage, detailDescription: self.cellDetail)
    }
}
