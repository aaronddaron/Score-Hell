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
            game.players[(game.dealer + 1) % game.players.count].leader = true
            
        }
        game.calcWinner()
    }
    
    var body: some View {
        NavigationStack{
            ZStack{
                /*Rectangle()
                    .fill(.gray)
                    .frame(maxHeight: .infinity)
                    .ignoresSafeArea()*/
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
                        NavigationLink(destination: FinishGameView(game: $game)){
                            Text("Finish")
                        }
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                    .font(.title)
                }
                //.tint(Color("orange"))
                .navigationBarBackButtonHidden(true)
                .onAppear {
                    let manager = SocketManager(socketURL: URL(string: "http://192.168.4.47:3000")!)
                    let socket = manager.defaultSocket
                    socket.connect()
                    game.setDealer()
                    game.players[game.dealer].dealer = true
                    game.players[(game.dealer + 1) % game.players.count].leader = true
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

