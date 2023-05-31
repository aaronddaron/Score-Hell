//
//  PlayerView.swift
//  Score Hell
//
//  Created by Aaron Geist on 5/22/23.
//

import SwiftUI

struct PlayerView: View {
    @Binding var player: Game.Player
    var phase: Int

    @Binding var game: Game
    
    @State private var showingAlert = false
    @State private var tempTotal = 0
        
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
            HStack{
                if phase == 0 {
                    TextField("Bid", value: $player.newBid, formatter: NumberFormatter())
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: player.newBid, perform: { newBid in
                            game.bidTotal = game.bidTotal - player.bid
                            game.bidTotal = game.bidTotal + newBid
                            player.bid = newBid
                            if player.name != game.players[game.players.count-1].name {
                                game.calcOhellNum()
                            }
                            game.socket.emit("bid", player.name, player.bid, game.ohellNum)
                            //game.socket.emit("ohell", game.ohellNum)
                    })
                }
                else if phase == 1{
                    TextField("Trick", value: $player.newTricksTaken, formatter: NumberFormatter())
                        .onChange(of: player.newTricksTaken, perform: { newTrick in
                            game.trickTotal = game.trickTotal - player.tricksTaken
                            player.tricksTaken = newTrick
                            game.trickTotal = game.trickTotal + player.tricksTaken
                            
                        })
                        .textFieldStyle(.roundedBorder)
                }
                Spacer()
                Image(systemName: "flame.fill")
                    .foregroundColor(.black)
                Text("\(player.streak)")
                    .foregroundColor(.black)
            }
        }
        .font(.title3)
        
    }
}



struct PlayerView_Previews: PreviewProvider {
    static var player = Game.sampleData.players[0]
    static var game = Game.sampleData
    static var previews: some View {
        PlayerView(player: .constant(player), phase: 0, game: .constant(game))
            
            
    }
}
