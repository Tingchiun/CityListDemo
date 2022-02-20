//
//  CityListDemoTests.swift
//  CityListDemoTests
//
//  Created by ChungTing on 2022/2/8.
//

import XCTest
import Promises
@testable import CityListDemo

class DataBuilder {

    private var path: URL?
    func path(_ assetName: String, _ extensionString: String) throws -> DataBuilder {
        let bundle = Bundle(for: CityListDemoTests.self)
        path = bundle.url(forResource: assetName, withExtension: extensionString)
        return self
    }

    func build() throws -> Data {
        let path = try XCTUnwrap(path)
        return try Data(contentsOf: path)
    }
}

class CityListDemoTests: XCTestCase {

    func testFoodDataModel() throws {
        let foodData = try DataBuilder().path("MockFoodList", "json").build()
        let foodModels = try JSONDecoder().decode([FoodDataModel].self, from: foodData)
        XCTAssertTrue(foodModels.count == 4)
    }

    func testCityDataModel() throws {
        let cityData = try DataBuilder().path("MockCityList", "json").build()
        let cityModels = try JSONDecoder().decode([CityDataModel].self, from: cityData)
        XCTAssertTrue(cityModels.count == 4)
    }
}
