//
//  ContentView.swift
//  Score Hell
//
//  Created by Aaron Geist on 5/22/23.
//

import SwiftUI

struct GameView: View {
    @State var phase = 0
    @Binding var game: Game
    @State var round = 1
    @State private var showingAlert = false
    
    
    var body: some View {
        VStack {
            VStack {
                HStack{
                    Text("Round \(round)")
                        .font(.title)
                    Spacer()
                    Text("\(game.cards[round - 1]) cards")
                        .font(.headline)
                }
                HStack {
                    Text("Aaron cannot bid \(game.ohellNum)")
                        .font(.headline)
                    Spacer()
                    Button(action: {}) {
                        Text("Full Score")
                    }
                }
            }
            .padding(.horizontal)
            List($game.players) { $player in
                PlayerView(player: $player, phase: phase, game: $game)
                    .listRowBackground(player.theme)
            }
            if phase == 0
            {
                Button(action: { phase = 1}) {
                    Text("Get Tricks")
                }
                .buttonStyle(.borderedProminent)
            }
            else
            {
                Button(action: {
                    
                    if game.trickTotal != game.numCards{
                        showingAlert = true
                    }
                    else {
                        phase = 0
                        game.numCards = game.cards[round]
                        round = round + 1
                        
                        let count = 0...game.players.count-1
                        for number in count{
                            game.players[number].updateScore()
                            game.players[number].bid = 0
                            game.players[number].newBid = 0
                            game.players[number].tricksTaken = 0
                        }
                        game.bidTotal = 0
                        game.trickTotal = 0
                        game.calcOhellNum()
                    }
                    
                    }) {
                    Text("Score")
                }
                .buttonStyle(.borderedProminent)
                .alert("Only \(game.trickTotal) tricks accounted for", isPresented: $showingAlert) {
                            Button("OK", role: .cancel) { }
                        }
            }
        }
    }
}
    
struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(game: .constant(Game.sampleData))
    }
}

