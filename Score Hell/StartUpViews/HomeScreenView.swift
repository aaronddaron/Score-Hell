//
//  HomeScreenView.swift
//  Score Hell
//
//  Created by Aaron Geist on 5/26/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct HomeScreenView: View {
    @State private var game = Game(players: [])
    @State private var roomCode = ""
    @State private var userPosition = 0
    @State private var signedOut = false
    @State private var join = false
    @State private var start = false
    @FocusState private var hideStart: Bool
    @State private var showingProfile = false
    @State var leaderFirst = true
    @State private var selectedTab = "one"
    @State private var bidsImage = "chart.bar.doc.horizontal"
    @State private var leaderImage = "crown"
    @State private var gamesImage = "house.fill"
    @State var account = User(name: "", theme: "", leaderFirst: true, pts: 0)
    
    var body: some View {
        if signedOut {
            LoginView()
        } else if join {
            PlayView(game: $game, playerName: account.name, playerTheme: account.theme, roomCode: roomCode, userPosition: userPosition, leaderFirst: account.leaderFirst)
        } else if start {
            HostView(game: $game, playerName: account.name, playerTheme: account.theme, leaderFirst: account.leaderFirst, roomCode: roomCode)
            
        } else {
            homeScreen
        }
    }
    
    var homeScreen: some View {
        NavigationStack {
            ZStack{
                LinearGradient(
                    colors: [Color("poppy"), Color("buttercup")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                VStack{
                    Spacer()
                
                    ZStack{
                        VStack{
                            Spacer()
                            Rectangle()
                                 .fill(Color("buttercup"))
                                 .ignoresSafeArea()
                                 .frame(maxHeight: 0.1)
                        }
                        TabView(selection: $selectedTab){
                            
                            GamesView(game: $game, signedOut: $signedOut, user: $account)
                            .tag("One")

                            BidsView()
                            .tag("Two")
                           
                            LeaderBoardView()
                                .tag("Three")
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .onChange(of: selectedTab) {newValue in
                            if selectedTab == "One"{
                                withAnimation{
                                    bidsImage = "chart.bar.doc.horizontal"
                                    leaderImage = "crown"
                                    gamesImage = "house.fill"
                                }
                                
                            } else if selectedTab == "Two" {
                                withAnimation{
                                    bidsImage = "chart.bar.doc.horizontal.fill"
                                    leaderImage = "crown"
                                    gamesImage = "house"
                                }
                                
                            } else {
                                withAnimation{
                                    bidsImage = "chart.bar.doc.horizontal"
                                    leaderImage = "crown.fill"
                                    gamesImage = "house"
                                }
                            }
                            let resign = #selector(UIResponder.resignFirstResponder)
                            UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
                        }
                        .foregroundColor(.black)
                        
                    
                    }
                
                }
                .font(.headline)
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar){
                        
                        Spacer()
                        Button(action: {
                            withAnimation{
                                selectedTab = "One"
                            }
                        }) {
                            Image(systemName: gamesImage)
                        }
                        .tint(Color("orange"))
                        
                        Spacer()
                        Button(action: {
                            withAnimation{
                                selectedTab = "Two"
                            }
                        }) {
                            Image(systemName: bidsImage)
                        }
                        .tint(Color("orange"))
                        
                        
                        Spacer()
                        Button(action: {
                            withAnimation{
                                selectedTab = "Three"
                            }
                        }) {
                            Image(systemName: leaderImage)
                        }
                        .tint(Color("orange"))
                        
                        Spacer()
                    }
                    
                    
                }
                
            }
            
        }
        .onAppear{
            
            game.socket.on("players") { data, ack -> Void in
                    let names = data[0] as! [String]
                    let themes = data[1] as! [String]
                    
                    game.numPlayers = names.count
                    game.players.removeAll()
                    //userPosition = game.numPlayers-1
                    for num in 0...game.numPlayers-1 {
                        game.players.append(Game.Player(name: names[num], theme: themes[num]))
                        
                        //game.numPlayers+=1
                        if account.name == game.players[num].name {
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
                if !start {
                    withAnimation{
                        join = true
                    }
            }
                    
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
            
            game.socket.on("code") { data, ack -> Void in
                roomCode = data[0] as! String
                game.players.append(Game.Player(name: account.name, theme: account.theme))
                game.numPlayers+=1
                withAnimation{
                    start = true
                }
            }

        }
        .navigationBarBackButtonHidden(true)
        
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}
