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
    @State private var showingFullScore = false
    
    private func updateGame() {
        phase = 0
        game.numCards = game.cards[round]
        round = round + 1
        
        let count = 0...game.players.count-1
        for number in count{
            game.players[number].updateScore()
            game.players[number].bid = 0
            game.players[number].newBid = 0
            game.players[number].tricksTaken = 0
            game.players[number].newTricksTaken = 0
        }
        game.bidTotal = 0
        game.trickTotal = 0
        game.calcOhellNum()
        
        game.players[game.dealer].dealer = false
        game.players[(game.dealer + 1) % game.numPlayers].leader = false
        game.dealer = (game.dealer + 1) % game.numPlayers
        game.players[game.dealer].dealer = true
        game.players[(game.dealer + 1) % game.numPlayers].leader = true
    }
    
    private func setUpGame() {
        game.setNumPlayers()
        game.setDealer()
        game.players[game.dealer].dealer = true
        game.players[(game.dealer + 1) % game.numPlayers].leader = true
    }
    
    var body: some View {
        VStack {
            VStack {
                HStack{
                    Text("Round \(round)")
                        .font(.title)
                    Spacer()
                    Button(action: {}) {
                        Text("Full Score")
                        .font(.headline)
                    }
                    .sheet(isPresented: $showingFullScore) {
                    }
                }
                HStack {
                    Text("\(game.players[game.dealer].name) cannot bid \(game.ohellNum)")
                        .font(.headline)
                    Spacer()
                    Text("\(game.cards[round - 1]) cards")
                        .font(.headline)
                }
            }
            .padding(.horizontal)
            List($game.players) { $player in
                PlayerView(player: $player, phase: phase, game: $game)
                    .listRowBackground(player.theme)
            }
            if phase == 0 {
                Button(action: { phase = 1}) {
                    Text("Play Round")
                }
                .buttonStyle(.borderedProminent)
                .disabled(game.bidTotal == game.numCards)
            } else {
                Button(action: {
                    if game.trickTotal == game.numCards {
                        updateGame()
                    }
                }) {
                    Text("Score")
                }
                .buttonStyle(.borderedProminent)
                .disabled(game.trickTotal != game.numCards)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            setUpGame()
        }
    }
}
    
struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(game: .constant(Game.sampleData))
    }
}

