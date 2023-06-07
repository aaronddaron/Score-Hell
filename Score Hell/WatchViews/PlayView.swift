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
    
    @State private var showingFullScore = false
    @State private var showingStats = false
    @State private var showingAlert = false
    @State var alert = ""
    //@State private var userPosition = 0
    @State private var player = Game.Player(name: "", theme: "")

    var body: some View {
        if game.finished {
            FinishGameView(game: $game)
        } else {
            watch
        }
    }

    var watch: some View {
        NavigationStack{
            VStack {
                GameHeaderView(game: $game, playerName: playerName, playerTheme: playerTheme, roomCode: $roomCode)
                List{
                    ForEach($game.players) { $player in
                        WatchPlayerView(player: $player, game: $game, showingStats: $showingStats)
                            .listRowBackground(Color(player.theme))
                    }
                    StatsDropDownView(showingStats: $showingStats)
                }
                
                StepperPlayView(game: $game, i: $userPosition)
                .padding(.horizontal)
                
                HStack {
                    if !game.started {
                        Text("Waiting for players")
                    } else if game.phase == 1{
                        Text("Playing Round")
                    } else if game.ohellNum < 0 {
                        Text("\(game.players[game.numPlayers-1].name) can bid anything")
                    } else {
                        Text("\(game.players[game.numPlayers-1].name) cannot bid \(game.ohellNum)")
                    }
                    
                }
                .font(.title)
                .padding()
            }
            .alert("Your \(alert)", isPresented: $showingAlert, actions: { // 3

                Button("Ok", role: .cancel, action: { showingAlert = false})

                    })
            .navigationBarBackButtonHidden()
        }
        .onAppear{
            //userPosition = game.numPlayers-1
            game.socket.on("players") { data, ack -> Void in
                let names = data[0] as! [String]
                let themes = data[1] as! [String]
                //var tempPlayer = Game.Player(name: "", theme: "")
                game.players.removeAll()
                
                for num in 0...game.numPlayers-1 {
                    game.players.append(Game.Player(name: names[num], theme: themes[num]))
                
                    
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
                    
                    if playerName == game.players[0].name {
                        showingAlert = true
                        alert = "lead"
                    } else if playerName == game.players[game.numPlayers-1].name{
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
                game.round += 1
                game.phase = 0
                game.bidTotal = 0
                game.trickTotal = 0
                
                for num in 0...game.numPlayers-1 {
                    game.players[num].bid = 0
                    game.players[num].tricksTaken = 0
                }
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
        PlayView(game: .constant(Game.sampleData), playerName: "Aaron", playerTheme: "lavender", roomCode: "ABCD", userPosition: 0)
    }
}
