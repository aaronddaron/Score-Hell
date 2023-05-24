//
//  Theme.swift
//  Score Hell
//
//  Created by Aaron Geist on 5/23/23.
//

import Foundation
struct Theme: Identifiable, Hashable{
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


