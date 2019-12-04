//
//  iTunes_SearchTests.swift
//  iTunes SearchTests
//
//  Created by Bobby Keffury on 12/4/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import XCTest
@testable import iTunes_Search

class iTunes_SearchTests: XCTestCase {

    func testSuccessfulMockSearch() {
        let controller = SearchResultController()
        
        let expectation = self.expectation(description: "Waiting for itunes API to return valid results.")
        
        // Load the file and send it back via completion.
        let bundle = Bundle(for: NetworkMockDownloader.self)
        let path = bundle.path(forResource: "iTunesAPIResults", ofType: "js")!
        let fileData = try! Data(contentsOf: URL(fileURLWithPath: path))
        
        let mockNetworkDownloader = NetworkMockDownloader()
        mockNetworkDownloader.data = fileData
        
        controller.performSearch(baseURL: controller.baseURL, for: "Tweetbot", resultType: .software, networkDownloader: mockNetworkDownloader) {
            
            XCTAssert(!controller.searchResults.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    
    func testEmptyMockSearch() {
        let controller = SearchResultController()
        
        let expectation = self.expectation(description: "Waiting for itunes API to return valid results.")

        let mockNetworkDownloader = NetworkMockDownloader()
        mockNetworkDownloader.data = nil
        
        controller.performSearch(baseURL: controller.baseURL, for: "Tweetbot", resultType: .software, networkDownloader: mockNetworkDownloader) {
            
            XCTAssert(controller.searchResults.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testInvalidJSONMockSearch() {
        let controller = SearchResultController()
        
        let expectation = self.expectation(description: "Waiting for itunes API to return valid results.")
        
        // Load the file and send it back via completion.
        let bundle = Bundle(for: iTunes_SearchTests.self)
        let path = bundle.path(forResource: "iTunesAPIInvalidResults", ofType: "js")!
        let fileData = try! Data(contentsOf: URL(fileURLWithPath: path))
        
        let mockNetworkDownloader = NetworkMockDownloader()
        mockNetworkDownloader.data = fileData
        
        controller.performSearch(baseURL: controller.baseURL, for: "Tweetbot", resultType: .software, networkDownloader: mockNetworkDownloader) {
            
            XCTAssert(controller.searchResults.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
}
