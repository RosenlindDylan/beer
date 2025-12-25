//
//  BeerTests.swift
//  BeerTests
//
//  Created by Travis Hand on 11/8/25.
//

import XCTest
import SQLite3
@testable import Beer

final class BeerTests: XCTestCase {
    
    
    func testDatabaseLoads() {
        let db = BeerDB.shared
        XCTAssertNotNil(db, "BeerDB.shared should not be nil")
    }

    func testLookupKnownBeer() {
        let result = BeerDB.shared.lookupBeer(byBarcode: "7802100003218")
        print("result = \(String(describing: result))")
        XCTAssertNotNil(result)
        XCTAssertEqual(result, "coors beer")
    }
    
    func testPrintBeerTableContents() {
        let db = BeerDB.shared
        var statement: OpaquePointer?

        let query = "SELECT code, productName FROM beers LIMIT 20;"
        sqlite3_prepare_v2(db.dbPtr(), query, -1, &statement, nil)

        print("\n--- DB CONTENTS ---")
        while sqlite3_step(statement) == SQLITE_ROW {
            let code = String(cString: sqlite3_column_text(statement, 0))
            let name = String(cString: sqlite3_column_text(statement, 1))
            print("ROW: \(code) -> \(name)")
        }
        print("--- END CONTENTS ---\n")

        sqlite3_finalize(statement)
    }

    func testLookupUnknownBeer() throws {
        let unknownBarcode = "0000000000000"

        let result = BeerDB.shared.lookupBeer(byBarcode: unknownBarcode)

        XCTAssertNil(result, "Lookup should return nil for a nonexistent barcode")
    }
    
    
//    
//
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
