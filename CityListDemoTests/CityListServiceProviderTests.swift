//
//  CityListServiceProviderTests.swift
//  CityListDemoTests
//
//  Created by ChungTing on 2022/2/19.
//

import XCTest
import CoreData
@testable import CityListDemo

class CityListServiceProviderTests: XCTestCase {

    lazy var testCityDataModel: CityDataModel = {
        return CityDataModel(name: "Taipei",
                             image: "http://for-testing-city-image-url-string",
                             description: "This is for testing the city description")
    }()

    func testCityServiceProvider() throws {
        let cityListServiceProvider = CityListServiceProvider()
        try cityListServiceProvider.clear()
        XCTAssertEqual(cityListServiceProvider.fallbackCityList.count, 0)

        cityListServiceProvider.cacheCityList(cityModel: testCityDataModel)
        let fallbackList = cityListServiceProvider.fallbackCityList
        XCTAssertEqual(fallbackList.count, 1)

        // check cached element
        let firstElemnt = try XCTUnwrap(fallbackList.first)
        XCTAssertEqual(firstElemnt.name, testCityDataModel.name)
        XCTAssertEqual(firstElemnt.image, testCityDataModel.image)
        XCTAssertEqual(firstElemnt.description, testCityDataModel.description)
        try cityListServiceProvider.clear()
    }
}
