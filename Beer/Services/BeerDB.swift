//
//  BeerDB.swift
//  Beer
//
//  Created by Dylan Kjell Rosenlind on 12/3/25.
//

import Foundation
import SQLite3

class BeerDB {
    static let shared = BeerDB()
    
    private var db: OpaquePointer?
    
    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    private init() {
        openDatabase()
    }
    
    private func openDatabase() {
        guard let dbPath = Bundle.main.path(forResource: "beercodes", ofType: "db") else {
            print("DB file not found in bundle.")
            return
        }
        
        if sqlite3_open_v2(dbPath, &db, SQLITE_OPEN_READONLY, nil) == SQLITE_OK {
            print("Opened beers database successfully!")
        } else {
            print("Failed to open database.")
        }
    }
    
    func dbPtr() -> OpaquePointer? {
        return db
    }
    
    func lookupBeer(byBarcode barcode: String) -> String? {
        let query = "SELECT productName FROM beers WHERE code = ? LIMIT 1;"
        var statement: OpaquePointer?

        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            print("❌ prepare error:", String(cString: sqlite3_errmsg(db)))
            return nil
        }

        defer { sqlite3_finalize(statement) }

        guard sqlite3_bind_text(statement, 1, barcode, -1, SQLITE_TRANSIENT) == SQLITE_OK else {
            print("❌ bind error:", String(cString: sqlite3_errmsg(db)))
            return nil
        }

        let stepResult = sqlite3_step(statement)
        print("sqlite3_step result =", stepResult)

        if stepResult == SQLITE_ROW {
            if let cString = sqlite3_column_text(statement, 0) {
                return String(cString: cString)
            }
        }

        return nil
    }
//
//    func lookupBeerName(byName name: String) -> String? {
//        let query = "SELECT productName FROM beers WHERE productName = ? LIMIT 1;"
//        var statement: OpaquePointer?
//
//        if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK {
//            let err = String(cString: sqlite3_errmsg(db))
//            print("❌ prepare error: \(err)")
//            return nil
//        }
//
//        if sqlite3_bind_text(statement, 1, name, -1, nil) != SQLITE_OK {
//            let err = String(cString: sqlite3_errmsg(db))
//            print("❌ bind error: \(err)")
//            return nil
//        }
//
//        // ONLY STEP ONCE
//        let stepResult = sqlite3_step(statement)
//        print("sqlite3_step result = \(stepResult)") // should equal SQLITE_ROW (100)
//        print("sqlite3_result statement: \(sqlite3_column_text(statement, 0))")
//
//        var result: String?
//        if stepResult == SQLITE_ROW {
//            if let cString = sqlite3_column_text(statement, 0) {
//                result = String(cString: cString)
//            }
//        } else {
//            print("❌ No row found or error: \(String(cString: sqlite3_errmsg(db)))")
//        }
//
//        sqlite3_finalize(statement)
//        return result
//    }
}
