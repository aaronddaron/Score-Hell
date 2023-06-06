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
    var round: Int
    var phase: Int
    var cards: [Int]
    var table: [Int]
    var numPlayers: Int
    var started: Bool
    var finished: Bool
    var manager: SocketManager
    var socket: SocketIOClient
    
    init( players: [Player]) {
        self.players = players
        self.ohellNum = 7
        self.bidTotal = 0
        self.trickTotal = 0
        self.numCards = 7
        self.round = 1
        self.phase = 0
        self.table = []
        self.started = false
        self.finished = false
        self.numPlayers = self.players.count
        self.cards = [7, 6, 5, 4, 3, 2, 1, 2, 3, 4, 5, 6, 7]
        self.manager = SocketManager(socketURL: URL(string: "http://192.168.4.47:3030")!)
        self.socket = manager.defaultSocket
    }
    
    mutating func order(leader: Int, host: String) -> Int {
        var temp: [Game.Player] = []
        var position = -1
        for num in 0...self.players.count - 1{
            temp.append(self.players[(leader + num) % self.players.count])
            if temp[num].name == host {
                position = num
            }
        }
        self.players = temp
        return position
    }
    
    mutating func setLeader(host: String) -> Int{
        let leader = Int.random(in: 0...self.players.count-1)
        let position = self.order(leader: leader, host: host)
        self.socket.emit("start", leader)
        return position
    }
    
    mutating func calcOhellNum() {
        self.ohellNum = self.numCards - bidTotal
    }
    
    mutating func newPositions(host: String) -> Int {
        var names: [String] = []
        var themes: [String] = []
        var i = 0
        var position = 0
        for player in players {
            names.append(player.name)
            themes.append(player.theme)
            if player.name == host {
                position = i
            }
            i+=1
        }
        
        socket.emit("newPositions", names, themes)
        return position
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
        
        var winners: [Bool] = []
        var scores: [Int] = []
        var streaks: [Int] = []
        var made: [Int] = []
        var zeros: [Int] = []
        var longest: [Int] = []
        for num in 0...self.players.count - 1{
            if self.players[max].score == self.players[num].score {
                players[num].winner = true
                winners.append(true)
            } else {
                winners.append(false)
            }
            scores.append(self.players[num].score)
            streaks.append(self.players[num].streak)
            made.append(self.players[num].bidsMade)
            zeros.append(self.players[num].bidZero)
            longest.append(self.players[num].longestStreak)
        }
        //self.socket.emit("scores", scores, streaks, made, zeros, longest)
        //self.socket.emit("winners", winners)
        self.socket.emit("nextRound", scores, winners, streaks, made, zeros, longest)
    }
    
    mutating func updateGame() -> Int{
        self.phase = 0
        var place = -1
        for number in 0...self.numPlayers-1{
            self.players[number].updateScore()
            self.players[number].bid = 0
            self.players[number].newBid = 0
            self.players[number].tricksTaken = 0
            self.players[number].newTricksTaken = 0
           
        }
        if self.round + 1 == 14 {
            self.bidTotal = self.numCards
        } else {
            self.numCards = self.cards[self.round]
            self.round += 1

            self.bidTotal = 0
            self.trickTotal = 0
            self.ohellNum = self.numCards
            
            place = self.order(leader: 1, host: "")
        }
        self.calcWinner()
        return place
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
        var bidsMade: Int
        var bidZero: Int
        var longestStreak: Int
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
            self.longestStreak = 0
            self.bidsMade = 0
            self.bidZero = 0
            self.winner = false
            self.scores = []
        }
        
        mutating func updateScore()
        {
            
            var sum = 0
            if tricksTaken == bid{
                sum = 10 + bid
                score = score + sum
                streak += 1
                bidsMade += 1
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
            
            if streak > longestStreak {
                longestStreak = streak
            }
            
            if bid == 0 {
                bidZero+=1
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
