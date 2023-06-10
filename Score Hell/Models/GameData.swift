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
    var date: String 
    var place: Int
    var score: Int
    var made: Int
    var finished: Bool
    var round: Int
    
    init(id: UUID = UUID(), date: String, place: Int, score: Int, made: Int, finished: Bool, round: Int){
        self.id = id
       // let myTimeInterval = TimeInterval(timestamp)
        //self.title = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        self.date = date
        self.score = score
        self.place = place
        self.made = made
        self.finished = finished
        self.round = round
    }
}

