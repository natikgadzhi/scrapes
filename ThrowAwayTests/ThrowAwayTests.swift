//
//  ThrowAwayTests.swift
//  ThrowAwayTests
//
//  Created by Natik Gadzhi on 12/23/23.
//

import XCTest

final class ThrowAwayTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // Test the URLSession recorder first
    //
    func testRequestURLToHost() {
        let url = KindleEndpoint.books.url
        let host = url.host()!
        XCTAssertEqual(host, "read.amazon.com")
    }
    
    func testRequestURLToFileName() {
        let url = KindleEndpoint.books.url
        
        let path = url.path()
        
        let query = url.query()
        
        var tapeFileName = path
        if let query {
            tapeFileName += "?" + query
        }
        
        tapeFileName += ".txt"
        
        XCTAssertEqual(tapeFileName, "/notebook?ref_=kcr_notebook_lib&language=en-US.txt")
    }
    
    

}
