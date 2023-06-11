//
//  WatchView.swift
//  Score Hell
//
//  Created by Aaron Geist on 5/25/23.
//

import SwiftUI
import SocketIO

struct WatchView: View {
    @Binding var game: Game
    var playerName: String
    var playerTheme: String
    @State var roomCode: String
    
    @State private var showingFullScore = false
    @State private var showingStats = false
    @State private var showingAlert = false
    @State var alert = ""

    var body: some View {
        if game.finished {
            FinishGameView(game: $game, playerName: playerName, title: "")
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
                        WatchPlayerView(player: $player, game: $game, showingStats: $showingStats, leaderFirst: true, deal: 0)
                        .listRowBackground(Color(player.theme))
                    }
                    StatsDropDownView(showingStats: $showingStats)
                }
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
            .navigationBarBackButtonHidden(true)
            .onAppear {
                //game.socket.connect(withPayload: ["username": playerName, "theme": playerTheme, "code": roomCode])
                
                game.socket.on("nextRound") { (data, ack) -> Void in
                    game.ohellNum = game.cards[game.round]
                    game.round += 1
                }
                
                game.socket.on("bid") { (data, ack) -> Void in
                    game.ohellNum = data[2] as! Int
                    
                }
                
                game.socket.on("winners"){ (data, ack) -> Void in
                    let winners = data[0] as! [Bool]
                    for num in 0...game.numPlayers-1 {
                        game.players[num].winner = winners[num]
                    }
                }
                
                game.socket.on("scores"){ (data, ack) -> Void in
                    let scores = data[0] as! [Int]
                    let streaks = data[1] as! [Int]
                    for num in 0...game.numPlayers-1 {
                        game.players[num].score = scores[num]
                        game.players[num].streak = streaks[num]
                    }
                }
                
                game.socket.on("game"){ (data, ack) -> Void in
                    let bids = data[0] as! [Int]
                    
                    for num in 0...game.numPlayers-1 {
                        game.players[num].bid = bids[num]
                    }
                    game.round = data[1] as! Int
                    game.ohellNum = data[2] as! Int
                    game.started = true
                }
                
                game.socket.on("players"){ (data, ack) -> Void in
                    let names = data[0] as! [String]
                    let themes = data[1] as! [String]
                    let addSelf = data[2] as! Bool
                    game.players.removeAll()
                    for num in 0...names.count-1 {
                        game.players.append(Game.Player(name: names[num], theme: themes[num]))
                    }
                    game.numPlayers = game.players.count

                    
                    if addSelf {
                        game.players.append(Game.Player(name: playerName, theme: playerTheme))
                        game.numPlayers+=1
                    }
                    if game.started {
                        if playerName == game.players[0].name {
                            showingAlert = true
                            alert = "lead"
                        } else if playerName == game.players[game.numPlayers-1].name {
                            showingAlert = true
                            alert = "deal"
                        }
                    }
                }
                
                game.socket.on("newPlayer"){ (data, ack) -> Void in
                    let tempName = data[0] as! String
                    let tempTheme = data[1] as! String
                    game.players.append(Game.Player(name: tempName, theme: tempTheme))
                    game.numPlayers+=1
                }
                
                game.socket.on("start"){ (data, ack) -> Void in
                    game.started = true
                }
                
                game.socket.on("finish"){ (data, ack) -> Void in
                    game.finished = true
                }

            }
            .onDisappear {
                game.socket.disconnect()
            }
            .alert("Your \(alert)", isPresented: $showingAlert, actions: { // 3

                Button("Ok", role: .cancel, action: { showingAlert = false})

                    })
        }
    }
}
    
struct WatchView_Previews: PreviewProvider {
    static var previews: some View {
        WatchView(game: .constant(Game.sampleData), playerName: "Aaron", playerTheme: "lavender", roomCode: "ABCD")
    }
}

