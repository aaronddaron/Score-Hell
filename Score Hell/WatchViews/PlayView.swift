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
    
    @State private var showingFullScore = false
    @State private var showingStats = false
    @State private var showingAlert = false
    @State var alert = ""
    @State private var userPosition = 0
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
            userPosition = game.numPlayers-1
            game.socket.on("players") { data, ack -> Void in
                let names = data[0] as! [String]
                let themes = data[1] as! [String]
                var tempPlayer = Game.Player(name: "", theme: "")
                
                game.players.removeAll()
                
                if data.count > 2 {
                    let scores = data[2] as! [Int]
                    let winners = data[3] as! [Bool]
                    let bids = data[4] as! [Int]
                    
                    for num in 0...game.numPlayers-1 {
                        tempPlayer.name = names[num]
                        tempPlayer.theme = themes[num]
                        tempPlayer.bid = bids[num]
                        tempPlayer.score = scores[num]
                        tempPlayer.winner = winners[num]
                        
                        game.players.append(tempPlayer)
                        
                        if playerName == game.players[num].name {
                            userPosition = num
                        }
                    }
                    
                } else {
                
                    for num in 0...game.numPlayers-1 {
                        game.players.append(Game.Player(name: names[num], theme: themes[num]))
                    
                        
                        if playerName == game.players[num].name {
                            userPosition = num
                        }
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
            
            game.socket.on("play") { data, ack -> Void in
                game.phase = 1
            }
            
            game.socket.on("nextRound") { data, ack -> Void in
                game.ohellNum = game.cards[game.round]
                game.round += 1
            }

        }
    }
}

struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        PlayView(game: .constant(Game.sampleData), playerName: "Aaron", playerTheme: "lavender", roomCode: "ABCD")
    }
}
