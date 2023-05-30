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
    
    @State private var leader = false
    @State private var dealer = false
    @State private var tempTotal = 0
    @State private var score = 0
    @State private var streak = 0
    @State private var winner = 0
    @State private var bid = 0
        
    var body: some View {
        VStack {
            
            HStack {
                if player.name == game.players[game.players.count - 1].name {
                    Image(systemName: "flame.circle")
                } else if player.name == game.players[0].name {
                    Image(systemName: "arrowtriangle.forward.fill")
                }
                
                Text("\(player.name)")
                Text("\(bid)")
                Spacer()
                
                if player.winner == true {
                    Image(systemName: "crown")
                }
                Text("\(score)")
            }
            .foregroundColor(.black)
            HStack{
                Image(systemName: "flame.fill")
                    .foregroundColor(.black)
                Text("\(streak)")
                    .foregroundColor(.black)
                Spacer()
                //Text("\(bid) + \(trick)")
            }
        }
        .font(.title)
        .onAppear{
            game.socket.on("bid") { (data, ack) -> Void in
                
                let name = data[0] as! String
                //bid = data[1] as! Int
                if name == player.name {
                    bid = data[1] as! Int
                }
            }
            game.socket.on("dealerLeader") { (data, ack) -> Void in
                if data[0] as! String == player.name {
                    dealer = true
                }
                else {
                    dealer = false
                }
                
                if data[1] as! String == player.name {
                    leader = true
                }
                else {
                    leader = false
                }
            }
            
            game.socket.on("score") { (data, ack) -> Void in
                if player.name == data[0] as! String {
                    score = data[1] as! Int
                    streak = data[2] as! Int
                }
            }
            
        }
    }
    
}



struct WatchPlayerView_Previews: PreviewProvider {
    static var player = Game.sampleData.players[0]
    static var game = Game.sampleData
    static var previews: some View {
        WatchPlayerView(player: .constant(player), game: .constant(game))
            
            
    }
}
