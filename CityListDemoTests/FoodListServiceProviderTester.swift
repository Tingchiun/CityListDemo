//
//  FoodListServiceProviderTester.swift
//  CityListDemoTests
//
//  Created by ChungTing on 2022/2/19.
//

import XCTest
import CoreData
@testable import CityListDemo

class FoodListServiceProviderTester: XCTestCase {

    lazy var testFoodDataModel: FoodDataModel = {
        return FoodDataModel(name: "Bubble Tea",
                             image: "http://for-testing-food-image-url-string")
    }()

    func testFoodServiceProvider() throws {

        let foodListServiceProvider = FoodListServiceProvider()
        try foodListServiceProvider.clear()
        XCTAssertEqual(foodListServiceProvider.fallbackFoodList.count, 0)

        foodListServiceProvider.cacheFoodList(foodModel: testFoodDataModel)
        let fallbackList = foodListServiceProvider.fallbackFoodList
        XCTAssertEqual(fallbackList.count, 1)

        let firstElemnt = try XCTUnwrap(fallbackList.first)
        XCTAssertEqual(firstElemnt.name, testFoodDataModel.name)
        XCTAssertEqual(firstElemnt.image, testFoodDataModel.image)
        try foodListServiceProvider.clear()
    }

}
