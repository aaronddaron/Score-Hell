//
//  PlayView.swift
//  Score Hell
//
//  Created by Aaron Geist on 6/5/23.
//

import SwiftUI

struct PlayView: View {
    @Binding var game: Game
    var playerName: String
    var playerTheme: String
    @State var roomCode: String
    @State  var userPosition: Int
    var leaderFirst: Bool
    
    @State private var showingFullScore = false
    @State private var showingStats = false
    @State private var showingAlert = false
    @State var alert = ""
    //@State private var userPosition = 0
    @State private var player = Game.Player(name: "", theme: "")
    @State private var nextRound = false
    
    @State var lead = 0
    @State var deal = 0
    @State var title = ""
    @State var stringDate = ""
    @State var date = Date.now

    var body: some View {
        if game.finished {
            FinishGameView(game: $game, playerName: playerName, title: title)
        } else {
            watch
        }
    }

    var watch: some View {
        NavigationStack{
            VStack {
                ZStack{
                    LinearGradient(
                        colors: [Color(playerTheme), Color(Theme(name: playerTheme).secondary)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    VStack{
                        GameHeaderView(game: $game, playerName: playerName, playerTheme: playerTheme, roomCode: $roomCode)
                        List{
                            ForEach($game.players) { $player in
                                WatchPlayerView(player: $player, game: $game, showingStats: $showingStats, leaderFirst: leaderFirst, deal: deal)
                                    .listRowBackground(Color(player.theme))
                            }
                            StatsDropDownView(showingStats: $showingStats)
                        }
                    }
                }
                ZStack{
                    
                    LinearGradient(
                        colors: [Color("poppy"), Color("buttercup")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    .frame(maxHeight: 150)
                    VStack{
                        StepperPlayView(game: $game, i: $userPosition, deal: deal)
                            .padding(.horizontal)
                        HStack {
                            if !game.started {
                                Text("Waiting for players")
                            } else if game.phase == 1{
                                Text("Playing Round")
                            } else if game.ohellNum < 0 {
                                Text("\(game.players[deal].name) can bid anything")
                            } else {
                                Text("\(game.players[deal].name) cannot bid \(game.ohellNum)")
                            }
                            
                        }
                        .font(.title)
                        .padding()
                    }
                }
                .alert("Your \(alert)", isPresented: $showingAlert, actions: { // 3
                    
                    Button("Ok", role: .cancel, action: { showingAlert = false})
                    
                })
                .navigationBarBackButtonHidden()
            }
        }
        .onAppear{
            deal = game.numPlayers-1
            if !leaderFirst {
                deal = 0
                lead = 1
            }
            //userPosition = game.numPlayers-1
            game.socket.on("players") { data, ack -> Void in
                let names = data[0] as! [String]
                let themes = data[1] as! [String]
                //var tempPlayer = Game.Player(name: "", theme: "")
                game.players.removeAll()
                game.numPlayers = names.count
                for num in 0...game.numPlayers-1 {
                    game.players.append(Game.Player(name: names[num], theme: themes[num]))
                
                    //game.numPlayers+=1
                    if playerName == game.players[num].name {
                        userPosition = num
                    }
                }
                
                if game.started {
                    let scores = data[2] as! [Int]
                    let winners = data[3] as! [Bool]
                    let bids = data[4] as! [Int]
                    let made = data[5] as! [Int]
                    
                    for num in 0...game.numPlayers-1 {
                        game.players[num].bid = bids[num]
                        game.players[num].score = scores[num]
                        game.players[num].winner = winners[num]
                        game.players[num].bidsMade = made[num]
                        
                    }
                    
                    if nextRound {
                        for num in 0...game.numPlayers-1 {
                            game.players[num].bid = 0
                            game.players[num].tricksTaken = 0
                        }
                    }
                    
                    if !leaderFirst && nextRound{
                        userPosition = game.order(leader: 1, host: playerName)
                        nextRound = false
                    }
                    
                    if playerName == game.players[lead].name {
                        showingAlert = true
                        alert = "lead"
                    } else if playerName == game.players[deal].name{
                        showingAlert = true
                        alert = "deal"
                    }
                }

                    
            }
                
            game.socket.on("newPlayer") { data, ack -> Void in
                let name = data[0] as! String
                let theme = data[1] as! String
                
                game.players.append(Game.Player(name: name, theme: theme))
                game.numPlayers+=1
                
            }
            
            game.socket.on("start") { data, ack -> Void in
                game.started = true
                nextRound = true
                date = Date.now
                let formatter = DateFormatter()
                formatter.dateFormat = "YYYY-MM-dd-HH"
                formatter.timeZone = TimeZone(secondsFromGMT: -18000)
                
                //var gameData = GameData(title: "", place: 0, score: 0, made: 0, finished: false, round: 0)
                stringDate = formatter.string(from: date)
                let db = Database()
                title = db.createGameData(date: stringDate)
            }
            
            game.socket.on("finish") { data, ack -> Void in
                game.finished = true
            }
            
            game.socket.on("bid") { data, ack -> Void in
                game.ohellNum = data[2] as! Int
                game.bidTotal = data[3] as! Int
            }
            
            game.socket.on("trick") { data, ack -> Void in
                game.trickTotal = data[2] as! Int
            }
            
            game.socket.on("play") { data, ack -> Void in
                game.phase = 1
            }
            
            game.socket.on("nextRound") { data, ack -> Void in
                game.ohellNum = game.cards[game.round]
                game.numCards = game.ohellNum
                
                game.phase = 0
                game.bidTotal = 0
                game.trickTotal = 0
                
                //calculate role and result
                var role = ""
                var result = ""
                if userPosition == deal {
                    role = "dealer"
                } else if userPosition == lead {
                    role = "leader"
                } else {
                    role = "none"
                }
                
                let t = game.players[userPosition].tricksTaken
                let b = game.players[userPosition].bid
                
                if t == b {
                    result = "made"
                } else if t > b {
                    result = "over"
                } else {
                    result = "under"
                }
                //setBid()
                let db = Database()
                db.setBid(bid: b, round: game.round, trick: t, result: result, role: role, title: title)
                
                game.round += 1
                nextRound = true
            }
            
            game.socket.on("gameData") { data, ack -> Void in
                let tempRound = data[0] as! Int
                
                if tempRound > 0 {
                    game.started = true
                    game.round = data[0] as! Int
                    game.numCards = game.cards[game.round-1]
                } 
                
                game.phase = data[1] as! Int
                game.ohellNum = data[2] as! Int
                game.bidTotal = data[3] as! Int
                game.trickTotal = data[4] as! Int
                
            }
            
            game.socket.on("N/A") { data, ack -> Void in
                game.finished = true
                
            }

        }
        
    }
}

struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        PlayView(game: .constant(Game.sampleData), playerName: "Aaron", playerTheme: "lavender", roomCode: "ABCD", userPosition: 0, leaderFirst: true)
    }
}
