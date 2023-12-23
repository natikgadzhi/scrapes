//
//  Item.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/23/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
