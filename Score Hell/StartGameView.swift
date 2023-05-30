//
//  StartGameView.swift
//  Score Hell
//
//  Created by Aaron Geist on 5/23/23.
//

import SwiftUI

struct StartGameView: View {
    @State private var game = Game(players: [])
    @State private var names: [String] = []
    @State private var themes: [String] = []
    @State private var playerName = ""
    @State private var playerTheme = ""
    @State private var place = 0
    //@State private var newCheck = 0
    
    var body: some View {
            NavigationStack{
                List{
                    Section (header: Text("Players")){
                        ForEach($game.players) { $player in
                            HStack{
                                Label(player.name, systemImage: "person")
                                Spacer()
                                Rectangle()
                                    .fill(player.theme)
                                    .frame(maxWidth: 20, maxHeight: 20)
                            }
                            
                        }
                        //.onDelete { indices in
                          //  game.players.remove(atOffsets: indices)}
                        if game.players.count < 6{
                            HStack{
                                
                                TextField("New Player", text: $playerName)
                                    .padding(.leading)
                                
                                Button(action: {
                                    //game.players.append(Game.Player(name: playerName, theme: Color(playerTheme)))
                                    game.socket.emit("newPlayer", playerName, playerTheme)
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
                   Section(header: Text("New Player Color")){
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
                    if game.players.count >= 4                    {
                        NavigationLink(destination: GameView(game: $game)) {
                            Label("Start Game", systemImage: "arrowtriangle.forward.fill")
                    }
                    }
                }
                .onAppear{
                    game.socket.on("players"){ (data, ack) -> Void in
                        names = data[0] as! [String]
                        themes = data[1] as! [String]
                        
                        for num in 0...names.count-1 {
                            game.players.append(Game.Player(name: names[num], theme: Color(themes[num])))
                            
                        }
                    }
                    game.socket.connect(withPayload: ["username": "Aaron", "theme": "lavender"])
                                        
                    game.socket.on("newPlayer"){ (data, ack) -> Void in
                        let tempName = data[0] as! String
                        let tempTheme = data[1] as! String
                        game.players.append(Game.Player(name: tempName, theme: Color(tempTheme)))
                        
                    }
                }
        }
    }
}

struct StartGameView_Previews: PreviewProvider {
    static var previews: some View {
        StartGameView()
    }
}
