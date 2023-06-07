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
    @State private var showingAlert = false
    @State private var alert = ""
    
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
                Text("\(game.players[game.numPlayers-1].name) can bid anything")
                    .font(.title)
            } else {
                Text("\(game.players[game.numPlayers-1].name) cannot bid \(game.ohellNum)")
                    .font(.title)
            }
            
            HStack{
                if !game.started {
                    EditButton()
                }
                
                if game.numPlayers >= 2 && !game.started {
                    Button(action: { userPosition = game.setLeader(host: playerName)
                        game.started = true
                        if playerName == game.players[0].name {
                            showingAlert = true
                            alert = "lead"
                        } else if playerName == game.players[game.numPlayers-1].name {
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
                        userPosition = game.updateGame(host: playerName)
                        if playerName == game.players[0].name {
                            showingAlert = true
                            alert = "lead"
                        } else if playerName == game.players[game.numPlayers-1].name {
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
        .buttonStyle(.borderedProminent)
        .font(.title3)
        .padding(.bottom)
        .alert("Your \(alert)", isPresented: $showingAlert, actions: {

            Button("Ok", role: .cancel, action: { showingAlert = false})

                })
    }
}

struct GameFooterView_Previews: PreviewProvider {
    static var previews: some View {
        GameFooterView(game: .constant(Game.sampleData), playerName: "Aaron", playerTheme: "lavender", userPosition: .constant(0))
    }
}
