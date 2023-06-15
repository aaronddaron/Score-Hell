//
//  User.swift
//  Score Hell
//
//  Created by Aaron Geist on 6/13/23.
//

import Foundation

class User: ObservableObject, Identifiable {
    var id: UUID
    var name: String
    var theme: String
    var leaderFirst: Bool
    var pts: Int
    var wins: Int
    var place: Int
    //var userPosition
    
    init(id: UUID = UUID(), name: String, theme: String, leaderFirst: Bool, pts: Int, wins: Int, place: Int){
        self.id = id
        self.name = name
        self.theme = theme
        self.leaderFirst = leaderFirst
        self.pts = pts
        self.wins = wins
        self.place = place
    }
}
