//
//  PlayView.swift
//  Score Hell
//
//  Created by Aaron Geist on 6/5/23.
//

import SwiftUI

struct HostView: View {
    @Binding var game: Game
    var playerName: String
    var playerTheme: String
    var leaderFirst: Bool
    @State var roomCode: String
    
    @State private var showingFullScore = false
    @State private var showingStats = false
    @State private var showingAlert = false
    //@State private var player = Game.Player(name: "", theme: "")
    @State var alert = ""
    @State private var userPosition = 0
    @State private var deal = 0

    
    var body: some View {
        NavigationStack{
            VStack {
                ZStack{
                    LinearGradient(
                        colors: [Color(playerTheme), Color(Theme(name: playerTheme).secondary)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    VStack{
                        GameHeaderView(game: $game, playerName: playerName, playerTheme: playerTheme, roomCode: $roomCode)
                        List{
                            ForEach($game.players) { $player in
                                WatchPlayerView(player: $player, game: $game, showingStats: $showingStats, leaderFirst: leaderFirst)
                                    .listRowBackground(Color(player.theme))
                            }
                            .onMove { from, to in
                                if !game.started {
                                    game.players.move(fromOffsets: from, toOffset: to)
                                    userPosition = game.newPositions(host: playerName)
                                }
                            }
                            StatsDropDownView(showingStats: $showingStats)
                        }
                    }
                }
                ZStack{
                
                    LinearGradient(
                        colors: [Color("poppy"), Color("buttercup")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    .frame(maxHeight: 150)
                    
                    VStack{
                        StepperPlayView(game: $game, i: $userPosition, deal: deal)
                        .padding(.horizontal)
                        GameFooterView(game: $game, playerName: playerName, playerTheme: playerTheme, userPosition: $userPosition, leaderFirst: leaderFirst, deal: $deal)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
        .onAppear{
            game.socket.disconnect()
            game.socket.connect(withPayload: ["username": playerName, "theme": playerTheme, "code": roomCode])
            
            game.socket.on("newPlayer") { data, ack -> Void in
                let name = data[0] as! String
                let theme = data[1] as! String
                
                game.players.append(Game.Player(name: name, theme: theme))
                game.numPlayers+=1
                
            }
            
            game.socket.on("players") { data, ack -> Void in
                let names = data[0] as! [String]
                let themes = data[1] as! [String]
    
                game.players.removeAll()
                game.numPlayers = themes.count
                
                for num in 0...game.numPlayers-1 {
                    game.players.append(Game.Player(name: names[num], theme: themes[num]))
                    
                    if playerName == game.players[num].name {
                        userPosition = num
                    }
                }
                /*game.players.append(Game.Player(name: String(game.numPlayers), theme: "tan"))*/
                
                if game.started{
                    let scores = data[2] as! [Int]
                    let winners = data[3] as! [Bool]
                    let bids = data[4] as! [Int]
                    let made = data[5] as! [Int]
                    
                    for num in 0...game.numPlayers-1 {
                        game.players[num].bid = bids[num]
                        game.players[num].score = scores[num]
                        game.players[num].winner = winners[num]
                        game.players[num].bidsMade = made[num]
                        
                    }
                }
                    
            }
            
            game.socket.on("bid") { data, ack -> Void in
                game.ohellNum = data[2] as! Int
                game.bidTotal = data[3] as! Int
            }
            
            game.socket.on("trick") { data, ack -> Void in
                game.trickTotal = data[2] as! Int
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

struct HostView_Previews: PreviewProvider {
    static var previews: some View {
        HostView(game: .constant(Game.sampleData), playerName: "Aaron", playerTheme: "lavender", leaderFirst: true, roomCode: "ABCD")
    }
}
