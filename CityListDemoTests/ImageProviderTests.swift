//
//  ImageProviderTests.swift
//  CityListDemoTests
//
//  Created by ChungTing on 2022/2/20.
//

import XCTest
import Promises
@testable import CityListDemo

class ImageProviderTester: MockURLProtocol, ImageFechable {
    var session: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }()
}

class ImageProviderTests: XCTestCase {

    func setupForImageFetchingTest() throws {
        let mockData = try DataBuilder()
            .path("betterLaptop", "png")
            .build()

        let unwrapMockData = try XCTUnwrap(mockData)
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse.init(url: request.url!, statusCode: 200, httpVersion: "2.0", headerFields: nil)!
            return (response, unwrapMockData)
        }
    }

    func testImageFetching() throws {
        try setupForImageFetchingTest()
        let imageFetchingTester = ImageProviderTester()
        let expectation = self.expectation(description: "imageFetching")
        imageFetchingTester
            .fetchImage(urlString: "http://This-is-a-image-test.com", name: "testName")
            .then { image in
                expectation.fulfill()
                XCTAssertEqual(image.size, CGSize(width: 768, height: 658) )
            }
        waitForExpectations(timeout: 5, handler: nil)
    }

}
