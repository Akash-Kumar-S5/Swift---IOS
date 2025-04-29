//
//  VechileTests.swift
//  unitTestingTests
//
//  Created by Akash Kumar S on 29/04/25.
//

import XCTest
@testable import unitTesting

final class VechileTests: XCTestCase {
    
    var mercedes: Vehicle!
    var boeing: Vehicle!

    override func setUpWithError() throws {
        mercedes = Vehicle(type: .Car)
        boeing = Vehicle(type: .PassengerAircraft)
    }

    override func tearDownWithError() throws {
        mercedes = nil
        boeing = nil
    }
    
    func testPlaneFasterThanCar() {
            //Act
            let minutes = 60
            
            //Arrenge
            mercedes.startEngine(minutes: minutes)
            boeing.startEngine(minutes: minutes)
            
            //Assert
            XCTAssertTrue(boeing.returnMiles() > mercedes.returnMiles())
        }
    
    func testFetchPostList() {
        let exp = expectation(description:"fetching post list from server")
        let session: URLSession = URLSession(configuration: .default)
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { data, response, error in
            XCTAssertNotNil(data,  "Expected non-nil data")
            exp.fulfill()
        }.resume()
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("Timed out waiting for response: \(error.localizedDescription)")
            }
        }
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
