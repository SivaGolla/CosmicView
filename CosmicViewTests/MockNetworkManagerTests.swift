//
//  MockNetworkManagerTests.swift
//  CosmicViewTests
//
//  Created by Venkata Sivannarayana Golla on 01/09/24.
//

import XCTest
@testable import CosmicView_Dev

final class MockNetworkManagerTests: XCTestCase {

    var networkManager: NetworkManager!
    var session: MockURLSession!
    
    override func setUpWithError() throws {
        session = MockURLSession()
        networkManager = NetworkManager(session: session)
    }

    override func tearDownWithError() throws {
        session = nil
        networkManager = nil
        try super.tearDownWithError()
    }

    func testExecuteRequestForURL() {
        
        guard let url = URL(string: "https://mockurl") else {
            fatalError("URL can't be empty")
        }
        
        let request = Request(path: "https://mockurl", 
                              method: .get,
                              contentType: "application/json",
                              headerParams: nil,
                              type: .picOfTheDay,
                              body: nil)
        
        networkManager.execute(request: request, completion: { [weak self](result: (Result<CosmicSnapshot, NetworkError>)) in
            if let sessionUrl = self?.session.lastURL {
                XCTAssert(sessionUrl == url)
            }
        })
        
    }
    
    func testExecuteDataTaskWithResumeCalled() {
        
        let dataTask = MockURLSessionDataTask()
        session.mockDataTask = dataTask
        
        let request = Request(path: "https://mockurl",
                              method: .get,
                              contentType: "application/json",
                              headerParams: nil,
                              type: .picOfTheDay,
                              body: nil)
        
        networkManager.execute(request: request, completion: { (result: (Result<[CosmicSnapshot], NetworkError>)) in
            
        })
        
        XCTAssert(dataTask.resumeWasCalled)
    }
    
    func testExecuteAsyncRequestForURL() async throws {
        
        guard let url = URL(string: "https://mockurl") else {
            fatalError("URL can't be empty")
        }
        
        let request = Request(path: "https://mockurl",
                              method: .get,
                              contentType: "application/json",
                              headerParams: nil,
                              type: .picOfTheDay,
                              body: nil)
        
        let result: Result<CosmicSnapshot, NetworkError> = try await networkManager.execute(request: request)
        
        if let sessionUrl = session.lastURL {
            XCTAssert(sessionUrl == url)
        }
        
        if case .success(let snapshot) = result {
            XCTAssertNotNil(snapshot)
        }
    }
}
