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
    @State private var joinGame = false
    @State private var userPosition = 0
    //@State private var disableAdd = false
    //@State private var showingAlert = false
    //@State private var alert = ""
    
    var body: some View {
        if joinGame{
            PlayView(game: $game, playerName: playerName, playerTheme: playerTheme, roomCode: roomCode, userPosition: userPosition)
        } else {
            join
        }
    }

    var join: some View {
        NavigationStack{
            List{
              /*  Section (header: Text("Connect")){
                 //   TextField("Screen Name", text: $playerName)*/

                    TextField("Room Code", text: $roomCode)

    
                 /*   }
                Section (header: Text("Colors")){
                    Picker("", selection: $playerTheme) {
                        ForEach(Theme.colors, id: \.self) { color in
                            ColorView(color: color)
                        }
                    }
                    .pickerStyle(.wheel)
                    
                }*/
            }
            //.edgesIgnoringSafeArea([.horizontal])
            .toolbar{
                if !playerTheme.isEmpty && !playerName.isEmpty && !roomCode.isEmpty{
                    Button("Join") {
                        game.socket.connect(withPayload: ["username": playerName, "theme": playerTheme, "code": roomCode])
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(playerTheme))
                }
            }
        }
        .onAppear{
            /*game.socket.on("join") { data, ack -> Void in
                joinGame = true
            }*/
            
            game.socket.on("players") { data, ack -> Void in
                let names = data[0] as! [String]
                let themes = data[1] as! [String]
                
                game.numPlayers = names.count
                //userPosition = game.numPlayers-1
                for num in 0...game.numPlayers-1 {
                    game.players.append(Game.Player(name: names[num], theme: themes[num]))
                    
                    if playerName == game.players[num].name {
                        userPosition = num
                    }
                }
                
                if game.started {
                    let scores = data[2] as! [Int]
                    let winners = data[3] as! [Bool]
                    let bids = data[4] as! [Int]
                    
                    for num in 0...game.numPlayers-1 {
                        game.players[num].bid = bids[num]
                        game.players[num].score = scores[num]
                        game.players[num].winner = winners[num]
                        
                    }
                }
                
                joinGame = true
                
                    
            }
            
            game.socket.on("gameData") { data, ack -> Void in
                let tempRound = data[0] as! Int
                
                if tempRound > 0 {
                    game.started = true
                    game.round = data[0] as! Int
                    game.numCards = game.cards[game.round-1]
                }
                
                game.phase = data[1] as! Int
                game.ohellNum = data[2] as! Int
                game.bidTotal = data[3] as! Int
                game.trickTotal = data[4] as! Int
                
            }

        }
    }
}

struct JoinGameView_Previews: PreviewProvider {
    static var previews: some View {
        JoinGameView()
    }
}
