//
//  PlayerView.swift
//  Score Hell
//
//  Created by Aaron Geist on 5/22/23.
//

import SwiftUI

struct PlayerView: View {
    @Binding var player: Game.Player
    //var phase: Int

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
                Text("\(player.bid)")
                Spacer()
                
                if player.winner == true {
                    Image(systemName: "crown")
                }
                Text("\(player.score)")
            }
            .foregroundColor(.black)
            HStack{
                if game.phase == 0 && game.started {
                    Picker("Bid", selection: $player.newBid) {
                        ForEach(0 ..< 8) {
                            Text("\($0)").tag("\($0)")
                        }
                    }
                    .onChange(of: player.newBid, perform: { newBid in
                        game.bidTotal = game.bidTotal - player.bid
                        game.bidTotal = game.bidTotal + newBid
                        player.bid = newBid
                        if player.name != game.players[game.players.count-1].name {
                            game.calcOhellNum()
                        }
                        game.socket.emit("bid", player.name, player.bid, game.ohellNum)
                    })
                    
                }
                else if game.phase == 1 && game.started{
                    Picker("Trick", selection: $player.newTricksTaken) {
                        ForEach(0 ..< 8) {
                            Text("\($0)").tag("\($0)")
                        }
                    }
                    .onChange(of: player.newTricksTaken, perform: { newTrick in
                            game.trickTotal = game.trickTotal - player.tricksTaken
                            player.tricksTaken = newTrick
                            game.trickTotal = game.trickTotal + player.tricksTaken
                            
                        })
                        .textFieldStyle(.roundedBorder)
                }
            }
        }
        .font(.title)
        
    }
}



struct PlayerView_Previews: PreviewProvider {
    static var player = Game.sampleData.players[0]
    static var game = Game.sampleData
    static var previews: some View {
        PlayerView(player: .constant(player), game: .constant(game))
            
            
    }
}
