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

    
    init(id: UUID = UUID(), name: String, index: Int){
        self.id = id
        self.name = name
    }
}

extension Theme {
    static let themes: [Theme] = [Theme(name: "bubblegum", index: 0), Theme(name: "buttercup", index: 1), Theme(name: "lavender", index: 2), Theme(name: "orange", index: 3), Theme(name: "poppy", index: 5), Theme(name: "seafoam", index: 6), Theme(name: "tan", index: 7)]
}

extension Theme {
    static let colors: [String] = ["", "bubblegum", "buttercup", "lavender", "orange", "poppy", "seafoam", "tan"]
}
