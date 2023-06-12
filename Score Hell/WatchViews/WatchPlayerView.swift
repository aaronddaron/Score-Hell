//
//  WatchPlayerView.swift
//  Score Hell
//
//  Created by Aaron Geist on 5/25/23.
//

import SwiftUI

import SwiftUI

struct WatchPlayerView: View {
    @Binding var player: Game.Player
    @Binding var game: Game
    @Binding var showingStats: Bool
    var leaderFirst: Bool
    //@State private var opaque = 1.0
    
    @State private var lead = 0
    @State var deal: Int
            
    var body: some View {
        ZStack{
            VStack {
                
                HStack {
                    if game.started{
                        if player.name == game.players[deal].name {
                            Image(systemName: "flame.circle")
                        } else if player.name == game.players[lead].name {
                            Image(systemName: "arrowtriangle.forward.fill")
                        }
                    }
                    
                    Text("\(player.name)")
                        //.background(Color(Theme(name: player.theme).secondary))
                        //.foregroundColor(Color("white"))
                    if player.bid < 0 {
                        Text("-")
                    } else {
                        Text("\(player.bid)")
                        
                    }
                    Spacer()
                    
                    if player.winner == true {
                        Image(systemName: "crown")
                    }
                    Text("\(player.score)")
                }
                .foregroundColor(.black)
                if showingStats {
                    StatsView(player: $player, game: $game)
                }
            }
            .font(.title)
            //.opacity(opaque)
        }
        .onAppear{
            //deal = game.numPlayers-1
            if !leaderFirst {
                deal = 0
                lead = 1
            }
            
            game.socket.on("bid") { (data, ack) -> Void in
                
                let name = data[0] as! String
                if name == player.name {
                    player.bid = data[1] as! Int
                    //opaque = 1.0
                }
                
            }
            game.socket.on("trick") { data, ack -> Void in
                let name = data[0] as! String
                if name == player.name {
                    player.tricksTaken = data[1] as! Int
                }
            }
            game.socket.on("start") { data, ack -> Void in
                deal = game.numPlayers-1
                if !leaderFirst {
                    deal = 0
                    lead = 1
                }
                //opaque = 0.5
            }
            
            game.socket.on("nextRound") { data, ack -> Void in
                //opaque = 0.5
            }
        }
    }
}



struct WatchPlayerView_Previews: PreviewProvider {
    static var player = Game.sampleData.players[0]
    static var game = Game.sampleData
    static var previews: some View {
        WatchPlayerView(player: .constant(player), game: .constant(game), showingStats: .constant(false), leaderFirst: true, deal: 0)
    }
}
