//
//  APIServiceProviderTests.swift
//  CityListDemoTests
//
//  Created by ChungTing on 2022/2/18.
//

import XCTest
import Promises
@testable import CityListDemo

// This comes from following reference: https://dev.to/quangdecember/testable-networking-in-ios-1-mock-urlprotocol-4jj0
class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data) )?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
    }

    override func stopLoading() {

    }

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            return
        }
        do {
            let (response, data)  = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch  {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
}

class MockDataFetcher: MockURLProtocol, APIServiceProvider {
    func fetch() { }
    var session: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }()
}

class APIServiceProviderTests: XCTestCase {

    override func setUpWithError() throws {
    }

    func setupForCityListTest() throws {
        let mockData = try DataBuilder()
            .path("MockFoodList", "json")
            .build()

        let unwrapMockData = try XCTUnwrap(mockData)
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse.init(url: request.url!, statusCode: 200, httpVersion: "2.0", headerFields: nil)!
            return (response, unwrapMockData)
        }
    }

    func testCityListAPIFetch() throws {
        try setupForCityListTest()

        let mockDataFetcher = MockDataFetcher()
        let expectation = self.expectation(description: "fetching")
        let promise: Promise<[CityDataModel]> = mockDataFetcher.fetchData(urlString: "https://this-is-a-test")
        promise.then { cities in
            expectation.fulfill()
            XCTAssertEqual(cities.count, 4)
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func setupForFoodListTest() throws {
        let mockData = try DataBuilder()
            .path("MockCityList", "json")
            .build()

        let unwrapMockData = try XCTUnwrap(mockData)
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse.init(url: request.url!, statusCode: 200, httpVersion: "2.0", headerFields: nil)!
            return (response, unwrapMockData)
        }
    }

    func testFoodListAPIFetch() throws {
        try setupForFoodListTest()

        let mockDataFetcher = MockDataFetcher()
        let expectation = self.expectation(description: "fetching")
        let promise: Promise<[FoodDataModel]> = mockDataFetcher.fetchData(urlString: "https://this-is-a-test")
        promise.then { food in
            expectation.fulfill()
            XCTAssertEqual(food.count, 4)
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
}
