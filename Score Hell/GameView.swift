//
//  ContentView.swift
//  Score Hell
//
//  Created by Aaron Geist on 5/22/23.
//

import SwiftUI
import SocketIO

struct GameView: View {
    
    @Binding var game: Game
    let playerName: String
    let playerTheme: String
    @Binding var names: [String]
    @Binding var themes: [String]
    
    @State private var showingStats = false
    
    var body: some View {
        NavigationStack {
            //VStack {
                 
                GameHeaderView(game: $game, playerName: playerName, playerTheme: playerTheme)
    
                List{
                    ForEach($game.players) { $player in
                        PlayerView(player: $player, showingStats: $showingStats, game: $game)
                        .listRowBackground(Color(player.theme))
                    }
                    .onMove { from, to in
                        if !game.started {
                            game.players.move(fromOffsets: from, toOffset: to)
                            game.newPositions()
                        }
                    }
                    StatsDropDownView(showingStats: $showingStats)
                }
            //}

            GameFooterView(game: $game, playerName: playerName, playerTheme: playerTheme)
                
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            game.socket.connect(withPayload: ["username": playerName, "theme": game.players[0].theme, "names": names, "themes": themes])
                    
            game.socket.on("game"){ (data, ack) -> Void in
                let bids = data[0] as! [Int]
                        
                for num in 0...game.numPlayers-1 {
                    game.players[num].bid = bids[num]
                }
                game.round = data[1] as! Int
                game.ohellNum = data[2] as! Int
                game.started = true
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
                    
            game.socket.on("players"){ (data, ack) -> Void in
                let names = data[0] as! [String]
                let themes = data[1] as! [String]
                        
                game.players.removeAll()
                for num in 0...names.count-1 {
                    game.players.append(Game.Player(name: names[num], theme: themes[num]))
                            
                }
                game.numPlayers = game.players.count
            }
            game.socket.on("newPlayer"){ (data, ack) -> Void in
                let tempName = data[0] as! String
                let tempTheme = data[1] as! String
                game.players.append(Game.Player(name: tempName, theme: tempTheme))
                game.numPlayers+=1
                        
            }
        }
    }
}

    
struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(game: .constant(Game.sampleData), playerName: "Aaron", playerTheme: "lavender", names: .constant([]), themes: .constant([]))
    }
}

