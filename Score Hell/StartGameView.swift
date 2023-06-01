//
//  StartGameView.swift
//  Score Hell
//
//  Created by Aaron Geist on 5/23/23.
//

import SwiftUI

struct StartGameView: View {
    @State private var game = Game(players: [])
    //@State private var updatePlayers: [Game.Player] = []
    //@State private var names: [String] = []
    //@State private var themes: [String] = []
    @State private var playerName = ""
    @State private var playerTheme = ""
    @State private var text = "Your Name"
    @State private var name = ""
    @State private var theme = ""
    @State private var names: [String] = []
    @State private var themes: [String] = []
    //@State private var place = 0
    
    var body: some View {
            NavigationStack{
                List{
                    Section (header: Text("Players")){
                        ForEach($game.players) { $player in
                            HStack{
                                Label(player.name, systemImage: "person")
                                Spacer()
                                Rectangle()
                                    .fill(Color(player.theme))
                                    .frame(maxWidth: 20, maxHeight: 20)
                            }
                            
                        }
                        .onDelete { indices in
                            game.players.remove(atOffsets: indices)}
                        if game.players.count < 6{
                            HStack{
                                
                                TextField(text, text: $playerName)
                                    .padding(.leading)
                                
                                Button(action: {
                                    game.players.append(Game.Player(name: playerName, theme: playerTheme))
                                    game.numPlayers+=1
                                    
                                    if text == "New Player" {
                                        names.append(playerName)
                                        themes.append(playerTheme)
                                    }
                                    else {
                                        name = playerName
                                        theme = playerTheme
                                    }
                                    
                                    text = "New Player"
                                    
                                    playerName = ""
                                    playerTheme = ""
                                }) {
                                    Image(systemName: "plus")
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(Color(playerTheme))
                                .disabled(playerName.isEmpty || playerTheme.isEmpty)
                            }
                        }
                    }
                   Section(header: Text("Colors")){
                       ForEach(Theme.themes) { theme in
                            Button (action: {
                                playerTheme = theme.name
                            }){
                                ColorView(color: theme.name)
                            }
                        }
                    }
                }
                .navigationTitle("New Game")
                .toolbar{
                    if game.numPlayers > 0{
                        NavigationLink(destination: GameView(game: $game, playerName: name, playerTheme: theme, names: $names, themes: $themes)) {
                            Text("Score")
                        }
                        .buttonStyle(.borderedProminent)
                    
                    }
                }
                .onAppear{
                   
                }
        }
    }
}

struct StartGameView_Previews: PreviewProvider {
    static var previews: some View {
        StartGameView()
    }
}
