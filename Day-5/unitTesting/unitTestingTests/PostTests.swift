//
//  PostTests.swift
//  unitTestingTests
//
//  Created by Akash Kumar S on 06/05/25.
// Testing n/w layer - https://medium.com/@mctok/testing-network-layer-in-swift-53e34b62f70c
//    XCTAssertEqual(a, b)
//    Asserts that two values are equal
//    XCTAssertNotEqual(a, b)
//    Asserts that two values are not equal
//    XCTAssertTrue(condition)
//    Asserts that a condition is true
//    XCTAssertFalse(condition)
//    Asserts that a condition is false
//    XCTAssertNil(value)
//    Asserts that a value is nil
//    XCTAssertNotNil(value)
//    Asserts that a value is not nil
//    XCTAssertThrowsError(expr)
//    Asserts that an expression throws an error
//    XCTAssertNoThrow(expr)
//    Asserts that an expression does not throw an error
//    XCTFail("message")
//    Unconditionally fails the test with a message


import XCTest
@testable import unitTesting

final class PostTests: XCTestCase {
    
    class MockURLProtocol: URLProtocol {
        static var mockData: Data?
        static var mockResponse: HTTPURLResponse?

        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }

        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }

        override func startLoading() {
            if let data = Self.mockData {
                client?.urlProtocol(self, didLoad: data)
            }

            if let response = Self.mockResponse {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }

            client?.urlProtocolDidFinishLoading(self)
        }

        override func stopLoading() {}
    }
    
    func testFetchPostsWithMockedResponse() async throws {
            let mockJSON = """
            [
                { "id": 1, "title": "Mock Title", "body": "Mock Body" }
            ]
            """.data(using: .utf8)!

            MockURLProtocol.mockData = mockJSON
            MockURLProtocol.mockResponse = HTTPURLResponse(
                url: URL(string: "https://jsonplaceholder.typicode.com/posts")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )

            let config = URLSessionConfiguration.ephemeral
            config.protocolClasses = [MockURLProtocol.self]
            let session = URLSession(configuration: config)

            let service = PostService(session: session)

            let posts = try await service.fetchPosts()

            XCTAssertEqual(posts.count, 1)
            XCTAssertEqual(posts.first?.title, "Mock Title")
        }
    
    class MockPostService: PostService {
        var mockPosts: [Post] = []

        override func fetchPosts() async throws -> [Post] {
            return mockPosts
        }
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchPostsReturnsMockData() async throws {
        let mockService = MockPostService()
        mockService.mockPosts = [
            Post(id: 1, title: "Title 1", body: "Body 1"),
            Post(id: 2, title: "Title 2", body: "Body 2")
        ]

        let posts = try await mockService.fetchPosts()

        XCTAssertEqual(posts.count, 2)
        XCTAssertEqual(posts.first?.title, "Title 1")
    }
    
    func testLoadPosts_UpdatesPublishedPosts() async throws {
        let mockService = MockPostService()
        mockService.mockPosts = [
            Post(id: 1, title: "Mock Title", body: "Mock Body")
        ]

        let viewModel = PostViewModel(service: mockService)

        await viewModel.loadPosts()

        XCTAssertEqual(viewModel.posts.count, 1)
        XCTAssertEqual(viewModel.posts.first?.title, "Mock Title")
        XCTAssertNil(viewModel.errorMessage)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
