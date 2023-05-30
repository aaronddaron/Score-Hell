//
//  WatchView.swift
//  Score Hell
//
//  Created by Aaron Geist on 5/25/23.
//

import SwiftUI
import SocketIO

struct WatchView: View {
    @Binding var game: Game
    @State var round = 1
    @State var bid = -1
    @State var ohell = 7
    @State var dealer = "?"
    @State var leader = "?"
    @State private var showingFullScore = false
    
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
                    WatchPlayerView(player: $player, game: $game)
                    .listRowBackground(player.theme)
                }
                HStack {
                    Text("\(dealer) cannot bid \(ohell)")
                }
                .font(.title)
                .padding()
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                game.socket.on("game") { (data, ack) -> Void in
                    round = round + 1
                    ohell = data[0] as! Int
                    dealer = data[1] as! String
                    leader = data[2] as! String
                    
                }
                game.socket.on("ohell") { (data, ack) -> Void in
                    ohell = data[0] as! Int
                    
                }
                
                game.socket.on("dealerLeader"){ (data, ack) -> Void in
                    dealer = data[0] as! String                    
                }
                //need to receive game.players.name
            }
            .onDisappear {
                game.socket.disconnect()
            }
        }
    }
}
    
struct WatchView_Previews: PreviewProvider {
    static var previews: some View {
        WatchView(game: .constant(Game.sampleData))
    }
}

