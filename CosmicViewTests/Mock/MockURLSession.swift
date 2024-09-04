//
//  MockURLSession.swift
//  CosmicViewTests
//
//  Created by Venkata Sivannarayana Golla on 03/09/24.
//

import Foundation
import UIKit

protocol MockURLSessionDelegate: AnyObject {
    func resourceName(for path: String, httpMethod: String) -> String
}

/// To create a mock URLSession that can be injected into the network layer for testing purposes, you can define a protocol that represents the network operations and provide the mock URLSession that loads data from a local JSON file.
class MockURLSession: URLSessionProtocol {
    
    weak var mDelegate: MockURLSessionDelegate? = nil

    var mockDataTask = MockURLSessionDataTask()
    var mockDownloadTask = MockURLSessionDownloadTask()
    var mockData: Data?
    var mockError: Error?
    var responseFileName: String = ""
    
    private (set) var lastURL: URL?
    
    func mockHttpURLResponse(request: URLRequest) -> URLResponse {
        return HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    
    func mockHttpURLResponse(url: URL) -> URLResponse {
        return HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        lastURL = request.url
        
        let bundle = Bundle(for: NetworkManager.self)
        responseFileName = mDelegate?.resourceName(for: lastURL?.absoluteString ?? "", httpMethod: request.httpMethod ?? RequestMethod.get.rawValue) ?? ""
        guard let mockResponseFileUrl = bundle.url(forResource: responseFileName, withExtension: "json"),
              let data = try? Data(contentsOf: mockResponseFileUrl) else {
            completionHandler(nil, nil, mockError)
            return mockDataTask
        }
        mockData = data
        
        completionHandler(mockData, mockHttpURLResponse(request: request), mockError)
        return mockDataTask
    }

    func dataTask(with url: URL, completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void) -> URLSessionDataTaskProtocol {
        
        lastURL = url
        
        let bundle = Bundle(for: NetworkManager.self)
        responseFileName = mDelegate?.resourceName(for: lastURL?.absoluteString ?? "", httpMethod: RequestMethod.get.rawValue) ?? ""
        
        guard let mockResponseFileUrl = bundle.url(forResource: responseFileName, withExtension: "jpg"),
              let data = try? Data(contentsOf: mockResponseFileUrl) else {
            completionHandler(nil, nil, mockError)
            return mockDataTask
        }
        mockData = data
        
        completionHandler(mockData, mockHttpURLResponse(url: url), mockError)
        return mockDataTask
    }
    
    func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        lastURL = request.url
        
        let bundle = Bundle(for: NetworkManager.self)
        responseFileName = mDelegate?.resourceName(for: lastURL?.absoluteString ?? "", httpMethod: request.httpMethod ?? RequestMethod.get.rawValue) ?? ""
        guard let mockResponseFileUrl = bundle.url(forResource: responseFileName, withExtension: "json"),
              let data = try? Data(contentsOf: mockResponseFileUrl) else {
            return (Data(), mockHttpURLResponse(request: request))
        }
        mockData = data
        
        return (data, mockHttpURLResponse(request: request))
    }
    
    func data(from url: URL, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        lastURL = url
        
        let bundle = Bundle(for: NetworkManager.self)
        responseFileName = mDelegate?.resourceName(for: lastURL?.absoluteString ?? "", httpMethod: RequestMethod.get.rawValue) ?? ""
        guard let mockResponseFileUrl = bundle.url(forResource: responseFileName, withExtension: "jpg"),
              let data = try? Data(contentsOf: mockResponseFileUrl) else {
            return (Data(), mockHttpURLResponse(url: url))
        }
        mockData = data
        
        return (data, mockHttpURLResponse(url: url))
    }
    
    func downloadTask(with url: URL, completionHandler: @escaping @Sendable (URL?, URLResponse?, (any Error)?) -> Void) -> URLSessionDownloadTaskProtocol {
        
        lastURL = url
        let bundle = Bundle(for: NetworkManager.self)
        guard let mockResponseFileUrl = bundle.url(forResource: "NetworkDownload_7f8PEa", withExtension: "tmp"),
              let data = try? Data(contentsOf: mockResponseFileUrl) else {
            return mockDownloadTask
        }
        
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let fileURL = cacheDirectory.appendingPathComponent("MockNetworkDownload_7f8PEa.tmp")
            
        try? data.write(to: fileURL)
        completionHandler(fileURL, mockHttpURLResponse(url: url), mockError)
        return mockDownloadTask
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    
    func resume() {
        resumeWasCalled = true
    }
}

class MockURLSessionDownloadTask: URLSessionDownloadTaskProtocol {
    private (set) var resumeWasCalled = false
    
    func resume() {
        resumeWasCalled = true
    }
}
