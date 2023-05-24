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
    @State private var showingFinish = false
    @State private var showingFullScore = false
    
    private func updateGame() {
        phase = 0
        game.numCards = game.cards[round]
        round = round + 1
                for number in 0...game.players.count-1{
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
        game.players[(game.dealer + 1) % game.players.count].leader = false
        game.dealer = (game.dealer + 1) % game.players.count
        game.players[game.dealer].dealer = true
        game.players[(game.dealer + 1) % game.players.count].leader = true
        
        game.calcWinner()
        if round == 14 {
            showingFinish = true
        }
    }
    
    var body: some View {
        ZStack{
            /*Rectangle()
                .fill(.gray)
                .frame(maxHeight: .infinity)
                .ignoresSafeArea()*/
            VStack {
                VStack {
                    HStack{
                        Text("\(game.cards[round - 1]) cards")
                            .font(.title)
                        Spacer()
                        Text("Round \(round)")
                            .font(.title)
                    }
                    HStack {
                        Text("\(game.players[game.dealer].name) cannot bid \(game.ohellNum)")
                            .font(.headline)
                        Spacer()
                        Button(action: { showingFullScore = true }) {
                            Text("Full Score")
                        }
                        .sheet(isPresented: $showingFullScore) {
                            NavigationStack {
                                FullScoreView(game: $game)
                                    .toolbar{
                                        ToolbarItem(placement: .confirmationAction) {
                                            Button("Done") {
                                                showingFullScore = false
                                            }
                                        }
                                    }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            
                List($game.players) { $player in
                    PlayerView(player: $player, phase: phase, game: $game)
                        .listRowBackground(player.theme)
                }
                //.scrollContentBackground(.hidden)
                //.background(.gray)
                
                HStack{
                    if phase == 0 {
                        Button(action: { phase = 1}) {
                            Text("Play Round")
                        }
                        .disabled(game.bidTotal == game.numCards)
                    } else {
                        Button(action: {
                            if game.trickTotal == game.numCards {
                                updateGame()
                            }
                        }) {
                            Text("Score")
                        }
                        .disabled(game.trickTotal != game.numCards)
                    }
                    Button(action: { showingFinish = true }) {
                        Text("Finish")
                    }
                    .alert("", isPresented: $showingFinish) {
                       Text("Won")
                    }
                }
                .padding()
                .buttonStyle(.borderedProminent)
            }
            //.tint(Color("orange"))
            .navigationBarBackButtonHidden(true)
            .onAppear {
                game.setDealer()
                game.players[game.dealer].dealer = true
                game.players[(game.dealer + 1) % game.players.count].leader = true
            }
        }
    }
}
    
struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(game: .constant(Game.sampleData))
    }
}

