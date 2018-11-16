//
//  APIClientTests.swift
//  TDD_ToDoTests
//
//  Created by Мишустин Сергеевич on 16/11/2018.
//  Copyright © 2018 LTD Zebka. All rights reserved.
//

import XCTest
@testable import TDD_ToDo

class APIClientTests: XCTestCase {
  
  var sut: APIClient!
  var mockURLSession: MockURLSession!
  
  override func setUp() {
    
    sut = APIClient()
    mockURLSession = MockURLSession(data: nil, urlResponse: nil, error: nil)
    sut.session = mockURLSession
  }
  
  override func tearDown() {}
  
  func test_Login_UsesExpectedHost() {
    sut.loginUser(withName: "dasdom", password: "1234", completion: mockURLSession.completion)
    
    XCTAssertEqual(mockURLSession.urlComponents?.host, "awesometodos.com")
  }
  
  func test_Login_UsesExpectedPath() {
    sut.loginUser(withName: "dasdom", password: "1234", completion: mockURLSession.completion)
    
    XCTAssertEqual(mockURLSession.urlComponents?.path, "/login")
  }
  
  func test_Login_UsesExpectedQuery() {
    sut.loginUser(withName:"dasdom", password: "1234", completion: mockURLSession.completion)
    XCTAssertEqual(mockURLSession.urlComponents?.percentEncodedQuery, "username=dasdom&password=1234")
  }
  
  func test_Login_WhenSuccessful_CreatesToken() {
    
    let jsonData = "{\"token\": \"1234567890\"}".data(using: .utf8)
    mockURLSession = MockURLSession(data: jsonData, urlResponse: nil, error: nil)
    sut.session = mockURLSession
    let tokenExpectation = expectation(description: "Token")
    var caughtToken: Token? = nil
    sut.loginUser(withName: "Foo", password: "Bar") { token, _ in
      caughtToken = token
      tokenExpectation.fulfill()
    }
    waitForExpectations(timeout: 1) { _ in
      XCTAssertEqual(caughtToken?.id, "1234567890")
    }
  }


}

extension APIClientTests {
  
  typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
  
  class MockURLSession: SessionProtocol {
    
    var url: URL?
    private let dataTask: MockTask
    let completion = { (token: Token?, error: Error?) in }
    
    var urlComponents: URLComponents? {
      guard let url = url else { return nil }
      return URLComponents(url: url, resolvingAgainstBaseURL: true)
    }
    
    init(data: Data?, urlResponse: URLResponse?, error: Error?) {
      dataTask = MockTask(data: data, urlResponse: urlResponse, error: error)
    }

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
      self.url = url
      print(url)
      dataTask.completionHandler = completionHandler
      return dataTask
    }
    
    
  }
  
  class MockTask: URLSessionDataTask {
    private let data: Data?
    private let urlResponse: URLResponse?
    private let responseError: Error?
    
    typealias CompletionHandler = (Data?, URLResponse?, Error?)
      -> Void
    var completionHandler: CompletionHandler?
    
    
    init(data: Data?, urlResponse: URLResponse?, error: Error?) {
      self.data = data
      self.urlResponse = urlResponse
      self.responseError = error
    }
    
    
    override func resume() {
      DispatchQueue.main.async() {
        self.completionHandler?(self.data,
                                self.urlResponse,
                                self.responseError)
      }
    }
  }
  
}
