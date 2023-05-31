//
//  Theme.swift
//  Score Hell
//
//  Created by Aaron Geist on 5/23/23.
//

import Foundation
struct Theme: Identifiable{
    var id: UUID
    var name: String
    var check: Bool
    var index: Int
    
    init(id: UUID = UUID(), name: String, index: Int){
        self.id = id
        self.name = name
        if name == "bubblegum" {
            self.check = true
        } else {
            self.check = false
        }
        self.index = index
    }
}

extension Theme {
    static let themes: [Theme] = [Theme(name: "bubblegum", index: 0), Theme(name: "buttercup", index: 1), Theme(name: "lavender", index: 2), Theme(name: "orange", index: 3), Theme(name: "poppy", index: 5), Theme(name: "seafoam", index: 6), Theme(name: "tan", index: 7)]
}

