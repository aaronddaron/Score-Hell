//
//  GameFooterView.swift
//  Score Hell
//
//  Created by Aaron Geist on 6/1/23.
//

import SwiftUI

struct GameFooterView: View {
    @Binding var game: Game
    let playerName: String
    let playerTheme: String
    @Binding var userPosition: Int
    var leaderFirst: Bool
    @State private var showingAlert = false
    @State private var alert = ""
    
    @State private var lead = 0
    @State private var deal = 0
    
    var body: some View {
        
        VStack{
            if !game.started {
                Text("Waiting For Players")
                .font(.title)
            }
            else if game.phase == 1 {
                Text("Playing Round")
                .font(.title)
            }
            else if game.ohellNum < 0 {
                Text("\(game.players[deal].name) can bid anything")
                    .font(.title)
            } else {
                Text("\(game.players[deal].name) cannot bid \(game.ohellNum)")
                    .font(.title)
            }
            
            HStack{
                if !game.started {
                    EditButton()
                }
                
                if game.numPlayers >= 2 && !game.started {
                    Button(action: { userPosition = game.setLeader(host: playerName, leaderFirst: leaderFirst)
                        game.started = true
                        if playerName == game.players[lead].name {
                            showingAlert = true
                            alert = "lead"
                        } else if playerName == game.players[deal].name {
                            showingAlert = true
                            alert = "deal"
                        }
                    }) {
                        Text("Start Game")
                    }
                }
                
                if game.phase == 0 && game.started {
                    Button(action: { game.phase = 1
                        game.socket.emit("play")}) {
                        Text("Play Round")
                        
                    }
                    .disabled(game.bidTotal == game.numCards)
                } else if game.phase == 1{
                    Button(action: {
                        userPosition = game.updateGame(host: playerName, leaderFirst: leaderFirst)
                        if playerName == game.players[lead].name {
                            showingAlert = true
                            alert = "lead"
                        } else if playerName == game.players[deal].name {
                            showingAlert = true
                            alert = "deal"
                        }
                    }) {
                        Text("Score")
                    }
                    .disabled(game.trickTotal != game.numCards)
                }
                NavigationLink(destination: FinishGameView(game: $game)){
                    Text("End Game")
                }
            }
        }
        .onAppear{
            deal = game.numPlayers-1
            if !leaderFirst {
                deal = 0
                lead = 1
            } 
        }
        .buttonStyle(.borderedProminent)
        .tint(Color("orange"))
        .foregroundColor(.black)
        .font(.title3)
        .padding(.bottom)
        .alert("Your \(alert)", isPresented: $showingAlert, actions: {

            Button("Ok", role: .cancel, action: { showingAlert = false})

                })
        
    }
}

struct GameFooterView_Previews: PreviewProvider {
    static var previews: some View {
        GameFooterView(game: .constant(Game.sampleData), playerName: "Aaron", playerTheme: "lavender", userPosition: .constant(0), leaderFirst: true)
    }
}
