//
//  StartGameView.swift
//  Score Hell
//
//  Created by Aaron Geist on 6/4/23.
//

import SwiftUI

struct StartGameView: View {
    @State private var name = ""
    @State private var game = Game(players: [])
    @State private var playerName = ""
    @State private var playerTheme = ""
    @State private var roomCode = ""
    @State private var showingJoin = false
    
    var body: some View {
        if !roomCode.isEmpty {
            HostView(game: $game, playerName: playerName, playerTheme: playerTheme, roomCode: roomCode)
        } else {
            start
        }
    }

    var start: some View {
        NavigationStack{
            List{
                Section (header: Text("Connect")){
                    TextField("Screen Name", text: $playerName)
    
                    }
                Section (header: Text("Colors")){
                    Picker("", selection: $playerTheme) {
                        ForEach(Theme.colors, id: \.self) { color in
                            ColorView(color: color)
                        }
                    }
                    .pickerStyle(.wheel)
                }
            }
            //.navigationTitle("Start Game")
            .toolbar{
                if !playerTheme.isEmpty && !playerName.isEmpty {
                    /*NavigationLink(destination: WatchView(game: $game, playerName: playerName, playerTheme: playerTheme, roomCode: roomCode))*/
                    Button("Start")
                    {
                        game.socket.connect(withPayload: ["username": playerName, "theme": playerTheme])
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(playerTheme))
                    .foregroundColor(.black)
                }
            }
        }
        .onAppear{
            game.socket.on("code") { data, ack -> Void in
                roomCode = data[0] as! String
                game.players.append(Game.Player(name: playerName, theme: playerTheme))
                game.numPlayers+=1
            }
        }
    }
}

struct StartGameView_Previews: PreviewProvider {
    static var previews: some View {
        StartGameView()
    }
}
