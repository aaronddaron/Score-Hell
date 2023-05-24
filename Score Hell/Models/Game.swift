//
//  Game.swift
//  Score Hell
//
//  Created by Aaron Geist on 5/22/23.
//

import Foundation
import SwiftUI

struct Game: Identifiable {
    var players: [Player]
    var themes: [Theme]
    var id: UUID
    var dealer: Int
    var ohellNum: Int
    var bidTotal: Int
    var trickTotal: Int
    var numCards: Int
    var cards: [Int]
    var numPlayers: Int
    
    init(id: UUID = UUID(), players: [Player]) {
        self.id = id
        self.players = players
        self.dealer = 0
        self.ohellNum = 7
        self.bidTotal = 0
        self.trickTotal = 0
        self.numCards = 7
        self.numPlayers = 0
        self.cards = [7, 6, 5, 4, 3, 2, 1, 2, 3, 4, 5, 6, 7]
        self.themes = [Theme(name: "bubblegum", index: 0), Theme(name: "buttercup", index: 1), Theme(name: "lavender", index: 2), Theme(name: "orange", index: 3), Theme(name: "periwinkle", index: 4), Theme(name: "poppy", index: 5), Theme(name: "seafoam", index: 6), Theme(name: "sky", index: 7), Theme(name: "tan", index: 8), Theme(name: "teal", index: 9), Theme(name: "yellow", index: 10)]
    }
    
    mutating func setDealer() {
        if numPlayers > 0 {
            self.dealer = Int.random(in: 0...numPlayers-1)
        }
    }
    mutating func setNumPlayers() {
        self.numPlayers = self.players.count
    }
    
    mutating func calcOhellNum() {
        self.ohellNum = self.numCards - bidTotal
    }
    
}

extension Game {
    struct Player: Identifiable {
        let id: UUID
        var name: String
        var score: Int
        var bid: Int
        var tricksTaken: Int
        var theme: Color
        var dealer: Bool
        var leader: Bool
        var newBid: Int
        var newTricksTaken: Int
        var streak: Int
        
        init(id: UUID = UUID(), name: String, theme: Color) {
            self.id = id
            self.name = name
            self.score = 0
            self.bid = 0
            self.newBid = 0
            self.newTricksTaken = 0
            self.tricksTaken = 0
            self.theme = theme
            self.streak = 0
            self.dealer = false
            self.leader = false        }
        mutating func updateScore()
        {
            if tricksTaken == bid{
                score = score + 10 + bid
            }
            else if ( tricksTaken > bid) {
                score = score - tricksTaken
            }
            else {
                score = score - bid
            }
        }
    }
}

extension Game {
        
    static let sampleData: Game = Game( players: [
        Player(name: "Aaron", theme: Color("lavender")),
        Player(name: "Dad", theme: Color("poppy")), Player(name: "Mom", theme: Color("seafoam")),
        Player(name: "Caroline", theme: Color("buttercup")), Player(name: "Bert", theme: Color("orange")), Player(name: "Suse", theme: Color("teal")) ] )
}
