//
//  TableInfo.swift
//  Score Hell
//
//  Created by Aaron Geist on 5/24/23.
//

import Foundation

struct TableInfo: Identifiable {
    var id: UUID
    var score: Int
    var sum: Int
    
    init(id: UUID = UUID(), score: Int, sum: Int)
    {
        self.id = id
        self.score = score
        self.sum = sum
    }
}

extension TableInfo {
    static let emptyTableInfo = TableInfo(score: 0, sum: 0)
}
