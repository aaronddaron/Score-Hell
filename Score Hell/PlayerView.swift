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
        VStack (alignment: .leading){
            
            HStack {
                Image(systemName: "flame")
                Text("\(player.name)")
                Text("\(player.bid)")
                Spacer()
                Image(systemName: "crown")
                Text("\(player.score)")
            }
            .foregroundColor(.black)
            HStack{
                if phase == 0 {
                    TextField("Bid", value: $player.newBid, formatter: NumberFormatter())
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: player.newBid, perform: { newBid in
                            tempTotal = game.bidTotal - player.bid
                            tempTotal = tempTotal + newBid
                        
                        if tempTotal == game.numCards && player.name == "Aaron" {
                            showingAlert = true
                        }
                        else {
                            game.bidTotal = tempTotal
                            player.bid = newBid
                            game.calcOhellNum()
                        }

                    })
                        .alert("Cannot bid \(player.newBid)", isPresented: $showingAlert) {
                        Button("OK", role: .cancel) { }
                            }
                        
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
