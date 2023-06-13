//
//  User.swift
//  Score Hell
//
//  Created by Aaron Geist on 6/13/23.
//

import Foundation

class User: ObservableObject {
    var name: String
    var theme: String
    var leaderFirst: Bool
    var pts: Int
    //var userPosition
    
    init(name: String, theme: String, leaderFirst: Bool, pts: Int){
        self.name = name
        self.theme = theme
        self.leaderFirst = leaderFirst
        self.pts = pts
    }
}
