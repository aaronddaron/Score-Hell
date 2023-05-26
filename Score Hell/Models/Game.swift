//
//  Game.swift
//  Score Hell
//
//  Created by Aaron Geist on 5/22/23.
//

import Foundation
import SwiftUI
import SocketIO

struct Game {
    var players: [Player]
    var themes: [Theme]
    var dealer: Int
    var ohellNum: Int
    var bidTotal: Int
    var trickTotal: Int
    var numCards: Int
    var cards: [Int]
    var table: [Int]
    var numPlayers: Int
    var manager: SocketManager
    var socket: SocketIOClient
    
    init( players: [Player]) {
        self.players = players
        self.dealer = 0
        self.ohellNum = 7
        self.bidTotal = 0
        self.trickTotal = 0
        self.numCards = 7
        self.table = []
        self.numPlayers = 0
        self.cards = [7, 6, 5, 4, 3, 2, 1, 2, 3, 4, 5, 6, 7]
        self.themes = [Theme(name: "bubblegum", index: 0), Theme(name: "buttercup", index: 1), Theme(name: "lavender", index: 2), Theme(name: "orange", index: 3), Theme(name: "periwinkle", index: 4), Theme(name: "poppy", index: 5), Theme(name: "seafoam", index: 6), Theme(name: "sky", index: 7), Theme(name: "tan", index: 8), Theme(name: "teal", index: 9), Theme(name: "yellow", index: 10)]
        self.manager = SocketManager(socketURL: URL(string: "http://192.168.4.47:3030")!)
        self.socket = manager.defaultSocket
            }
    
    mutating func setDealer() {
        
        self.dealer = Int.random(in: 0...self.players.count-1)
        
    }
    mutating func setNumPlayers() {
        self.numPlayers = self.players.count
    }
    
    mutating func calcOhellNum() {
        self.ohellNum = self.numCards - bidTotal
    }
    
    mutating func calcWinner() {
        var max = 0
        
        for num in 0...self.players.count - 1{
            players[num].winner = false;
        }
        
        for num in 0...self.players.count - 1 {
            if self.players[max].score < self.players[num].score {
                max = num
            }
        }
        self.players[max].winner = true
        for num in 0...self.players.count - 1{
            if self.players[max].score == self.players[num].score {
                players[num].winner = true;
            }
        }
    }
    mutating func clearChecks()
    {
        for num in 0...self.themes.count - 1{
            themes[num].check = false
        }
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
        var winner: Bool
        var newBid: Int
        var newTricksTaken: Int
        var streak: Int
        var scores: [TableInfo]
        
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
            self.winner = false
            self.leader = false
            self.scores = []
        }
        
        mutating func updateScore()
        {
            var sum = 0
            if tricksTaken == bid{
                sum = 10 + bid
                score = score + sum
                streak = streak + 1
            }
            else if ( tricksTaken > bid) {
                sum = -1 * tricksTaken
                score = score + sum
                streak = 0
            }
            else {
                sum = -1 * bid
                score = score + sum
                streak = 0
            }
            self.scores.append(TableInfo(score: self.score, sum: sum))
        }
    }
}

extension Game {
        
    static let sampleData: Game = Game( players: [
        Player(name: "Aaron", theme: Color("lavender")),
        Player(name: "Dad", theme: Color("poppy")), Player(name: "Mom", theme: Color("seafoam")),
        Player(name: "Caroline", theme: Color("buttercup")), Player(name: "Bert", theme: Color("orange")), Player(name: "Suse", theme: Color("teal")) ] )
}
