//
//  Item.swift
//  Beer
//
//  Created by Travis Hand on 11/8/25.
//

import Foundation
import SwiftData

@Model
final class BeerItem {
    var timestamp: Date
    var type: String
    
    init(timestamp: Date, type: String) {
        self.timestamp = timestamp
        self.type = type
    }
}
