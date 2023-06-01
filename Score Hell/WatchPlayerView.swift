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
    
    //@State private var bid = 0
        
    var body: some View {
        VStack {
            
            HStack {
                if player.name == game.players[game.players.count - 1].name {
                    Image(systemName: "flame.circle")
                } else if player.name == game.players[0].name {
                    Image(systemName: "arrowtriangle.forward.fill")
                }
                
                Text("\(player.name)")
                Text("\(player.bid)")
                Spacer()
                
                if player.winner == true {
                    Image(systemName: "crown")
                }
                Text("\(player.score)")
            }
            .foregroundColor(.black)
            if showingStats {
                HStack{
                    Image(systemName: "flame")
                        .foregroundColor(.black)
                    Text("\(player.streak)")
                        .foregroundColor(.black)
                    Spacer()
                    //Text("\(bid) + \(trick)")
                }
            } 
        }
        .font(.title)
        .onAppear{
            game.socket.on("bid") { (data, ack) -> Void in
                
                let name = data[0] as! String
                //bid = data[1] as! Int
                if name == player.name {
                    player.bid = data[1] as! Int
                }
            }
        }
    }
}



struct WatchPlayerView_Previews: PreviewProvider {
    static var player = Game.sampleData.players[0]
    static var game = Game.sampleData
    static var previews: some View {
        WatchPlayerView(player: .constant(player), game: .constant(game), showingStats: .constant(false))
    }
}
