//
//  StartGameView.swift
//  Score Hell
//
//  Created by Aaron Geist on 5/23/23.
//

import SwiftUI

struct StartGameView: View {
    @State private var game = Game(players: [])
    //@State private var game = Game.sampleData
    @State private var playerName = ""
    var body: some View {
        NavigationStack
        {
            Form{
                Section (header: Text("Players")){
                    ForEach(game.players) { player in
                        HStack {
                            Label(player.name, systemImage: "person")
                            
                        }
                        
                    }
                    .onDelete { indices in
                        game.players.remove(atOffsets: indices)}
                    HStack{
                        TextField("New Player", text: $playerName)
                            .padding(.leading)
                        Button(action: {
                            game.players.append(Game.Player(name: playerName, theme: Color("poppy")))
                            playerName = ""
                        }) {
                                Image(systemName: "plus")
                            }
                    }
                    NavigationLink(destination: GameView(game: $game)) {
                        Label("Start Game", systemImage: "arrowtriangle.forward.fill")
                    }
            
                }
            
            }
            .navigationTitle("New Game")
        }
    }
}

struct StartGameView_Previews: PreviewProvider {
    static var previews: some View {
        StartGameView()
    }
}
