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
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
