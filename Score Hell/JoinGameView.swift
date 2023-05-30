//
//  JoinGameView.swift
//  Score Hell
//
//  Created by Aaron Geist on 5/26/23.
//

import SwiftUI

struct JoinGameView: View {
    @State private var themes: [String] = []
    @State private var names: [String] = []
    @State private var name = ""
    @State private var game = Game(players: [])
    //@State private var players: [Game.Player] = []
    @State private var playerName = ""
    @State private var playerTheme = ""
    @State private var showingJoin = false

    var body: some View {
        VStack{
            ForEach(game.players){ player in
                HStack{
                    Label(player.name, systemImage: "person")
                    Spacer()
                    Rectangle()
                        .fill(player.theme)
                        .frame(maxWidth: 20, maxHeight: 20)
                }
            }
            HStack{
                TextField("Name", text: $playerName)
                Button(action: {
                    game.socket.connect(withPayload: ["username": playerName, "theme": playerTheme])
                    playerName = ""
                    playerTheme = ""
                }) {
                    Image(systemName: "plus")
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(playerTheme))
                .disabled(playerName.isEmpty || playerTheme.isEmpty)
                
            }
            VStack {
                ForEach(Theme.themes) { theme in
                    Button (action: {
                        playerTheme = theme.name
                    }){
                        ColorView(color: theme.name)
                    }
                }
                Spacer()
                if showingJoin == true
                {
                    NavigationStack{
                        NavigationLink(destination: WatchView(game: $game)){
                            Label("Join Game", systemImage: "person.3")
                        }
                    }
                }
            }
        }
        .padding()
        .onAppear{
            game.socket.on("players"){ (data, ack) -> Void in
                names = data[0] as! [String]
                themes = data[1] as! [String]
                for num in 0...names.count-1 {
                    game.players.append(Game.Player(name: names[num], theme: Color(themes[num])))
                    
                }
            }
            
            game.socket.on("newPlayer"){ (data, ack) -> Void in
                let tempName = data[0] as! String
                let tempTheme = data[1] as! String
                game.players.append(Game.Player(name: tempName, theme: Color(tempTheme)))
                
            }
            
            game.socket.on("start"){ (data, ack) -> Void in
                showingJoin = true
                //game.players.append(contentsOf: players)
            }
        }
    }
}

struct JoinGameView_Previews: PreviewProvider {
    static var previews: some View {
        JoinGameView()
    }
}
