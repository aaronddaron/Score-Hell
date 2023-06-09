//
//  GameData.swift
//  Score Hell
//
//  Created by Aaron Geist on 6/8/23.
//

import Foundation

struct GameData: Identifiable{
    var id: UUID
    //var title: NSDate
    var title: String
    var place: Int
    var score: Int
    var made: Int
    
    init(id: UUID = UUID(), title: String, place: Int, score: Int, made: Int){
        self.id = id
       // let myTimeInterval = TimeInterval(timestamp)
        //self.title = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        self.title = title
        self.score = score
        self.place = place
        self.made = made
    }
}

