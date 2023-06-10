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
    var secondary: String

    
    init(id: UUID = UUID(), name: String){
        self.id = id
        self.name = name
        
        if name == "bubblegum" {
            self.secondary = "purple"
        } else if name == "buttercup" {
            self.secondary = "teal"
        } else if name == "lavender" {
            self.secondary = "poppy"
        } else if name == "orange" {
            self.secondary = "buttercup"
        } else if name == "poppy" {
            self.secondary = "indigo"
        } else if name == "seafoam" {
            self.secondary = "navy"
        } else if name == "tan" {
            self.secondary = "magenta"
        } else {
            self.secondary = "buttercup"
        }
    }
}

extension Theme {
    static let themes: [Theme] = [Theme(name: "bubblegum"), Theme(name: "buttercup"), Theme(name: "lavender"), Theme(name: "orange"), Theme(name: "poppy"), Theme(name: "seafoam"), Theme(name: "tan")]
}

extension Theme {
    static let colors: [String] = [ "bubblegum", "buttercup", "lavender", "orange", "poppy", "seafoam", "tan"]
}
