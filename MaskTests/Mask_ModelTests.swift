//
//  Mask_ModelTests.swift
//  MaskTests
//
//  Created by 何安竺 on 2022/10/6.
//

import XCTest

class Mask_ModelTests: XCTestCase {
    var sut : URLSession!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = URLSession.init(configuration: .default)

    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }
    func testMaskAPI() throws{
        callTo(urlStr: "https://raw.githubusercontent.com/kiang/pharmacies/master/json/points.json")
        callTo(urlStr: "https://tw.feature.appledaily.com/collection/dailyquote")
    }
    
    func callTo(urlStr: String){
        let url = URL(string: urlStr)
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        // when
        let dataTask = sut.dataTask(with: url!) { (data, response, error) in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
        
        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
    
    
}
