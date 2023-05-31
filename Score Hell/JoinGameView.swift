//
//  JoinGameView.swift
//  Score Hell
//
//  Created by Aaron Geist on 5/26/23.
//

import SwiftUI

struct JoinGameView: View {
    //@State private var themes: [String] = []
    //@State private var names: [String] = []
    @State private var name = ""
    @State private var game = Game(players: [])
    //@State private var players: [Game.Player] = []
    @State private var playerName = ""
    @State private var playerTheme = ""
    @State private var showingJoin = false
    @State private var disableAdd = false
    @State private var showingAlert = false
    @State private var alert = ""

    var body: some View {
        NavigationStack{
            List{
                Section (header: Text("Screen Name")){
                    HStack{
                        TextField("Name", text: $playerName)
                        Spacer()
                        
                            .foregroundColor(Color(playerTheme))
                        }
                    }
                Section (header: Text("Colors")){
                    ForEach(Theme.themes) { theme in
                        Button (action: {
                            playerTheme = theme.name
                        }){
                            ColorView(color: theme.name)
                        }
                    }
                    
                }
            }
            .navigationTitle("Join Game")
            .toolbar{
                if !playerTheme.isEmpty && !playerTheme.isEmpty{
                    NavigationLink(destination: WatchView(game: $game, playerName: playerName, playerTheme: playerTheme)) {
                        Text("Join")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(playerTheme))
                }
            }
        }
    }
}

struct JoinGameView_Previews: PreviewProvider {
    static var previews: some View {
        JoinGameView()
    }
}
