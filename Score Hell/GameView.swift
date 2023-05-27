//
//  ContentView.swift
//  Score Hell
//
//  Created by Aaron Geist on 5/22/23.
//

import SwiftUI
import SocketIO

struct GameView: View {
    @State var phase = 0
    @Binding var game: Game
    @State var round = 1
    @State var leader = 0
    @State private var showingFinish = false
    @State private var showingFullScore = false
    
    private func updateGame() {
        phase = 0
        for number in 0...game.players.count-1{
            game.players[number].updateScore()
            game.players[number].bid = 0
            game.players[number].newBid = 0
            game.players[number].tricksTaken = 0
            game.players[number].newTricksTaken = 0
            game.socket.emit("score", game.players[number].name, game.players[number].score, game.players[number].streak)
        }
        if round + 1 == 14 {
            game.bidTotal = game.numCards
        } else {
            game.numCards = game.cards[round]
            round = round + 1

            game.bidTotal = 0
            game.trickTotal = 0
            game.calcOhellNum()
            
            game.players[game.dealer].dealer = false
            game.players[(game.dealer + 1) % game.players.count].leader = false
            game.dealer = (game.dealer + 1) % game.players.count
            game.players[game.dealer].dealer = true
            leader = (game.dealer + 1) % game.players.count
            game.players[leader].leader = true
            
        }
        game.calcWinner()
        game.socket.emit("game", game.ohellNum, game.players[game.dealer].name, game.players[leader].name)
    }
    
    var body: some View {
        NavigationStack{
                VStack {
                    VStack {
                        HStack{
                            Text("\(game.cards[round - 1]) cards")
                            Spacer()
                            Text("Round \(round)")
                        }
                        .font(.largeTitle)
                        HStack {
                            Text("\(game.players[game.dealer].name) cannot bid \(game.ohellNum)")
                            Spacer()
                            Button(action: { showingFullScore = true }) {
                                Text("Full Score")
                            }
                            .sheet(isPresented: $showingFullScore) {
                                NavigationStack{
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
                        .font(.title2)
                    }
                    .padding(.horizontal)
                
                    List($game.players) { $player in
                        PlayerView(player: $player, phase: phase, game: $game)
                            .listRowBackground(player.theme)
                    }
                    
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
                        NavigationLink(destination: FinishGameView(game: $game)){
                            Text("End Game")
                        }
                        Button("dealerLeader") {
                            game.socket.emit("dealerLeader", game.players[game.dealer].name, game.players[leader].name)
                        }
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                    .font(.title3)
                }
                .navigationBarBackButtonHidden(true)
                .onAppear {
                    game.setDealer()
                    
                    game.players[game.dealer].dealer = true
                    leader = (game.dealer + 1) % game.players.count
                    game.players[leader].leader = true
                    //game.socket.connect()

                }
            }
    }
}
    
struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(game: .constant(Game.sampleData))
    }
}

