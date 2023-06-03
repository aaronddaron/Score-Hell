//
//  JoinGameView.swift
//  Score Hell
//
//  Created by Aaron Geist on 5/26/23.
//

import SwiftUI

struct JoinGameView: View {
    @State private var name = ""
    @State private var game = Game(players: [])
    @State private var playerName = ""
    @State private var playerTheme = ""
    @State private var roomCode = ""
    @State private var showingJoin = false
    //@State private var disableAdd = false
    //@State private var showingAlert = false
    //@State private var alert = ""

    var body: some View {
        NavigationStack{
            List{
                Section (header: Text("Connect")){
                    TextField("Screen Name", text: $playerName)

                    TextField("Room Code", text: $roomCode)

    
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
            .edgesIgnoringSafeArea([.horizontal])
            .navigationTitle("Join Game")
            .toolbar{
                if !playerTheme.isEmpty && !playerName.isEmpty && !roomCode.isEmpty{
                    NavigationLink(destination: WatchView(game: $game, playerName: playerName, playerTheme: playerTheme, roomCode: roomCode)) {
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
