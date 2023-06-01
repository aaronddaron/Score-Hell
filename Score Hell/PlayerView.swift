//
//  PlayerView.swift
//  Score Hell
//
//  Created by Aaron Geist on 5/22/23.
//

import SwiftUI

struct PlayerView: View {
    @Binding var player: Game.Player
    @Binding var showingStats: Bool

    @Binding var game: Game
    
    @State private var showingAlert = false
    @State private var tempTotal = 0
        
    var body: some View {
        VStack {
            
            HStack {
                if player.name == game.players[game.players.count - 1].name && game.started{
                    Image(systemName: "flame.circle")
                } else if player.name == game.players[0].name && game.started{
                    Image(systemName: "arrowtriangle.forward.fill")
                }
                
                Text("\(player.name)")
                if game.phase == 1 {
                    Text("\(player.bid)")
                }
                Spacer()
                
                if player.winner {
                    Image(systemName: "crown")
                }
                Text("\(player.score)")
            }
            .foregroundColor(.black)
            
            HStack{
                if game.phase == 0 && game.started {
                    Stepper{Text("Bid: \(player.bid)")} onIncrement: {
                        player.bid += 1
                        if player.bid > game.numCards {
                            player.bid = 0
                            game.bidTotal -= game.numCards
                        } else {
                            game.bidTotal += 1
                        }
                        
                        if player.name != game.players[game.numPlayers-1].name {
                            game.calcOhellNum()
                        }
                        game.socket.emit("bid", player.name, player.bid, game.ohellNum)
                        
                    } onDecrement: {
                        player.bid -= 1
                        if player.bid  < 0 {
                            player.bid = game.numCards
                            game.bidTotal += game.numCards
                        } else {
                            game.bidTotal -= 1
                        }
                        
                        if player.name != game.players[game.numPlayers-1].name {
                            game.calcOhellNum()
                        }
                        game.socket.emit("bid", player.name, player.bid, game.ohellNum)
                    }
                }
                else if game.phase == 1 {
                    Stepper{Text("Tricks: \(player.tricksTaken)")} onIncrement: {
                        
                        player.tricksTaken += 1
                        
                        if player.tricksTaken > game.numCards {
                            player.tricksTaken = 0
                            game.trickTotal -= game.numCards
                        } else {
                            game.trickTotal += 1
                        }
                        
                    } onDecrement: {
                        
                        player.tricksTaken -= 1
                        
                        if player.tricksTaken  < 0 {
                            player.tricksTaken = game.numCards
                            game.trickTotal += game.numCards
                        } else {
                            game.trickTotal -= 1
                        }
                    }
                }
            }
            if showingStats {
                StatsView(player: $player)
            }
            
        }
        .font(.title)
        
    }
}



struct PlayerView_Previews: PreviewProvider {
    static var player = Game.sampleData.players[0]
    static var game = Game.sampleData
    static var previews: some View {
        PlayerView(player: .constant(player), showingStats: .constant(false), game: .constant(game))
            
            
    }
}
