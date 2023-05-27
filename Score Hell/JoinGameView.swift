//
//  JoinGameView.swift
//  Score Hell
//
//  Created by Aaron Geist on 5/26/23.
//

import SwiftUI

struct JoinGameView: View {
    @State private var game = Game(players: [])
    @State private var playerName = ""
    @State private var playerTheme = ""
    @State private var showingJoin = false
    @State private var array = [1, 2, 3, 4, 5]

    var body: some View {
        VStack{
            if showingJoin == true
            { Text("\(game.players[0].name)") }
            HStack{
                TextField("Join with name", text: $playerName)
                Button(action: {
                    game.socket.emit("newPlayer", playerName, playerTheme, array)
                    playerName = ""
                    playerTheme = ""
                }) {
                    Image(systemName: "plus")
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(playerTheme))
                .disabled(playerName.isEmpty || playerTheme.isEmpty || showingJoin == true)
                
            }
            VStack {
                ForEach($game.themes) { $theme in
                    Button (action: {
                        playerTheme = theme.name
                    }){
                        ColorView(color: theme.name, check: theme.check)
                    }
                }
                Spacer()
                if showingJoin == true
                {
                    NavigationStack{
                        NavigationLink(destination: WatchView(game: $game)){
                            Text("Join Game")
                        }
                    }
                }
            }
        }
        .padding()
        .onAppear{
            game.socket.connect()
            game.socket.on("newPlayer") { (data, ack) -> Void in
                showingJoin = true
                playerName = data[0] as! String
                playerTheme = data[1] as! String
                game.players.append(Game.Player(name: playerName, theme: Color(playerTheme)))
                playerName = ""
                playerTheme = ""
            }
        }
        .onDisappear{
            game.socket.disconnect()
        }
    }
}

struct JoinGameView_Previews: PreviewProvider {
    static var previews: some View {
        JoinGameView()
    }
}
