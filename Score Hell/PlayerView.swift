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
        
    var body: some View {
        VStack (alignment: .leading){
            
            HStack {
                Image(systemName: "flame")
                Text("\(player.name)")
                Text("\(player.bid)")
                Spacer()
                Image(systemName: "crown")
                Text("\(player.score)")
            }
            HStack{
                if phase == 0 {
                    TextField("Bid", value: $player.newBid, formatter: NumberFormatter())
                        .textFieldStyle(.roundedBorder)
                    Button(action: {
                        game.bidTotal = game.bidTotal - player.bid
                        player.bid = player.newBid
                        player.newBid = 0
                        game.bidTotal = game.bidTotal + player.bid
                        game.calcOhellNum()
                        
                        if game.bidTotal == game.numCards && player.name == "Aaron" {
                            showingAlert = true
                        }

                    }) {
                        Image(systemName: "chevron.right.circle.fill")
                    }
                    .alert("Aaron Can't Bid That", isPresented: $showingAlert) {
                                Button("OK", role: .cancel) { }
                            }
                }
                else if phase == 1{
                    TextField("Trick", value: $player.tricksTaken, formatter: NumberFormatter())
                        .onChange(of: player.tricksTaken, perform: { newtrick in
                            
                        })
                        .textFieldStyle(.roundedBorder)
                }
            }
        }
        .font(.title3)
        .foregroundColor(.black)
    }
}



struct PlayerView_Previews: PreviewProvider {
    static var player = Game.sampleData.players[0]
    static var game = Game.sampleData
    static var previews: some View {
        PlayerView(player: .constant(player), phase: 0, game: .constant(game))
            
            
    }
}
