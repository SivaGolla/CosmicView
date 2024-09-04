//
//  AstroServiceTests.swift
//  CosmicViewTests
//
//  Created by Venkata Sivannarayana Golla on 03/09/24.
//

import XCTest
@testable import CosmicView_Dev

final class AstroServiceTests: XCTestCase {

    var networkManager: NetworkManager!
    var session: MockURLSession!
    var astroService: AstroService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        session = MockURLSession()
        session.mDelegate = self
        networkManager = NetworkManager(session: session)
        astroService = AstroService()
    }

    override func tearDownWithError() throws {
        astroService = nil
        networkManager = nil
        session.mDelegate = nil
        session = nil
        try super.tearDownWithError()
    }

    func testMakeRequestWithCount() {
        // Arrange
        let requestParams = CosmicSnapshotRequestModel(id: UUID().uuidString,
                                                       date: nil,
                                                       startDate: nil,
                                                       endDate: nil,
                                                       count: 5,
                                                       thumbs: nil)
        astroService.urlSearchParams = requestParams
        
        // Act
        let request = astroService.makeRequest()
        
        // Assert
        XCTAssertNotNil(request)
        XCTAssertEqual(request.path, "\(Environment.mediaOfTheData)&count=5")
    }

    func testMakeRequestWithDate() {
        // Arrange
        let requestParams = CosmicSnapshotRequestModel(id: UUID().uuidString,
                                                       date: Date(),
                                                       startDate: nil,
                                                       endDate: nil,
                                                       count: nil,
                                                       thumbs: nil)
        astroService.urlSearchParams = requestParams
        
        // Act
        let request = astroService.makeRequest()
        
        // Assert
        XCTAssertNotNil(request)
        XCTAssertTrue((request.path).contains("&date="))
    }

    func testMakeRequestWithStartDateAndEndDate() {
        // Arrange
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
        let requestParams = CosmicSnapshotRequestModel(id: UUID().uuidString,
                                                       date: nil,
                                                       startDate: startDate,
                                                       endDate: endDate,
                                                       count: nil,
                                                       thumbs: nil)
        astroService.urlSearchParams = requestParams
        
        // Act
        let request = astroService.makeRequest()
        
        // Assert
        XCTAssertNotNil(request)
        XCTAssertTrue(request.path.contains("&start_date="))
        XCTAssertTrue(request.path.contains("&end_date="))
    }

    func testFetchCompletion() throws {
        // Arrange
        let bundle = Bundle(for: NetworkManager.self)
        guard let mockResponseFileUrl = bundle.url(forResource: "PictureOfTheDayResponse", withExtension: "json"),
              let data = try? Data(contentsOf: mockResponseFileUrl) else {
            XCTFail("Expected success, but got failure")
            return
        }
        
        let model = try JSONDecoder().decode(CosmicSnapshot.self, from: data)
                
        let expectation = XCTestExpectation(description: "Completion handler invoked")
        
        // Act
        let urlSearchParams = CosmicSnapshotRequestModel(id: UUID().uuidString, date: Date().cosmicDate(from: "2024-09-03"))
        
        astroService.urlSearchParams = urlSearchParams
        
        astroService.fetch { (result: Result<CosmicSnapshot, NetworkError>) in
            // Assert
            switch result {
            case .success(let data):
                XCTAssertEqual(data, model)
            case .failure:
                XCTFail("Expected success, but got failure")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchAsync() async throws {
        // Arrange Mock Data
        let bundle = Bundle(for: NetworkManager.self)
        guard let mockResponseFileUrl = bundle.url(forResource: "PictureOfTheDayResponse", withExtension: "json"),
              let data = try? Data(contentsOf: mockResponseFileUrl) else {
            XCTFail("Expected success, but got failure")
            return
        }
        
        let model = try JSONDecoder().decode(CosmicSnapshot.self, from: data)
                
        // Act
        let urlSearchParams = CosmicSnapshotRequestModel(id: UUID().uuidString, date: Date().cosmicDate(from: "2024-09-03"))
        
        astroService.urlSearchParams = urlSearchParams
        
        let result: Result<CosmicSnapshot, NetworkError> = try await astroService.fetch()
        
        // Assert
        switch result {
        case .success(let fetchedData):
            XCTAssertEqual(fetchedData, model)
        case .failure:
            XCTFail("Expected success, but got failure")
        }
    }

}

extension AstroServiceTests: MockURLSessionDelegate {
    func resourceName(for path: String, httpMethod: String) -> String {
        return "PictureOfTheDayResponse"
    }
}
