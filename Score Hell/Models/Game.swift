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
        self.ohellNum = 7
        self.bidTotal = 0
        self.trickTotal = 0
        self.numCards = 7
        self.table = []
        self.numPlayers = players.count
        self.cards = [7, 6, 5, 4, 3, 2, 1, 2, 3, 4, 5, 6, 7]
        self.manager = SocketManager(socketURL: URL(string: "http://192.168.4.47:3030")!)
        self.socket = manager.defaultSocket
    }
    
    mutating func order(leader: Int) {
        var temp: [Game.Player] = []
        for num in 0...self.players.count - 1{
            temp.append(self.players[(leader + num) % self.players.count])
        }
        self.players = temp
    }
    mutating func setLeader() {
        let leader = Int.random(in: 0...self.players.count-1)
    
        self.order(leader: leader)
        self.socket.emit("start", leader)
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
        //self.players[max].winner = true
        var winners: [Bool] = []
        var scores: [Int] = []
        var streaks: [Int] = []
        for num in 0...self.players.count - 1{
            if self.players[max].score == self.players[num].score {
                players[num].winner = true
                winners.append(true)
            } else {
                winners.append(false)
            }
            scores.append(self.players[num].score)
            streaks.append(self.players[num].streak)
        }
        self.socket.emit("scores", scores, streaks)
        self.socket.emit("winners", winners)
    }
}

extension Game {
    struct Player: Identifiable {
        let id: UUID
        var name: String
        var score: Int
        var bid: Int
        var tricksTaken: Int
        var theme: String
        var winner: Bool
        var newBid: Int
        var newTricksTaken: Int
        var streak: Int
        var scores: [TableInfo]
        
        init(id: UUID = UUID(), name: String, theme: String) {
            self.id = id
            self.name = name
            self.score = 0
            self.bid = 0
            self.newBid = 0
            self.newTricksTaken = 0
            self.tricksTaken = 0
            self.theme = theme
            self.streak = 0
            self.winner = false
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
        Player(name: "Aaron", theme: "lavender"),
        Player(name: "Dad", theme: "poppy"), Player(name: "Mom", theme: "seafoam"),
        Player(name: "Caroline", theme: "buttercup") ])
}
