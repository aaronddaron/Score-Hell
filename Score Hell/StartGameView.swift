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
    @State private var playerTheme = ""
    @State private var array: [Int] = [0, 0, 0, 0, 0]
    //@State private var newCheck = 0
    
    var body: some View {
            NavigationStack{
                List{
                    Section (header: Text("Players")){
                        ForEach(game.players) { player in
                            HStack{
                                Label(player.name, systemImage: "person")
                                Spacer()
                                Rectangle()
                                    .fill(player.theme)
                                    .frame(maxWidth: 20, maxHeight: 20)
                            }
                        }
                        .onDelete { indices in
                            game.players.remove(atOffsets: indices)}
                        if game.players.count < 6{
                            HStack{
                                
                                TextField("New Player", text: $playerName)
                                    .padding(.leading)
                                
                                Button(action: {
                                    game.players.append(Game.Player(name: playerName, theme: Color(playerTheme)))
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
                   Text("\(array[0]), \(array[1]), \(array[2]), \(array[3]), \(array[4])")
                   Section(header: Text("New Player Color")){
                        ForEach($game.themes) { $theme in
                            Button (action: {
                                //game.clearChecks()
                                //game.themes[newCheck].check = false
                                playerTheme = theme.name
                                //theme.check = true
                                //newCheck = theme.index
                            }){
                                ColorView(color: theme.name, check: theme.check)
                            }
                        }
                    }
                }
                .navigationTitle("New Game")
                //.scrollContentBackground(.hidden)
                //.background(Color("poppy"))
                .toolbar{
                    if game.players.count >= 4                    {
                        NavigationLink(destination: GameView(game: $game)) {
                            Label("Start Game", systemImage: "arrowtriangle.forward.fill")
                    }
                    }
                }
                .onAppear{
                    game.socket.connect()
                    game.socket.on("newPlayer") { (data, ack) -> Void in
                        playerName = data[0] as! String
                        playerTheme = data[1] as! String
                        array = data[2] as! [Int]
                        game.players.append(Game.Player(name: playerName, theme: Color(playerTheme)))
                        playerName = ""
                        playerTheme = ""
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
