//
//  HomeScreenView.swift
//  Score Hell
//
//  Created by Aaron Geist on 5/26/23.
//

import SwiftUI
import Firebase

struct HomeScreenView: View {
    @State private var game = Game(players: [])
    @State private var playerName = ""
    @State private var playerTheme = ""
    @State private var roomCode = ""
    @State private var userPosition = 0
    @State private var signedOut = false
    @State private var join = false
    @State private var start = false
    //private var db = Database()
    
    var body: some View {
        if signedOut {
            LoginView()
        } else if join {
            PlayView(game: $game, playerName: playerName, playerTheme: playerTheme, roomCode: roomCode, userPosition: userPosition)
        } else if start {
            HostView(game: $game, playerName: playerName, playerTheme: playerTheme, roomCode: roomCode)
        } else {
            homeScreen
        }
    }
    
    var homeScreen: some View {
        NavigationStack{
            Text("Score Hell")
                .font(.title)
                .foregroundColor(Color("orange"))
            Text(playerName)
            /*.padding(.horizontal)
            .background(Color(playerTheme))
            .cornerRadius(10)
            .font(.title2)
            .foregroundColor(.black)*/
                //.foregroundColor(Color(playerTheme))
            Spacer()
            
            VStack{
                TextField("Room Code", text: $roomCode)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 150)
                
                NavigationLink (destination: JoinGameView()){
                    Label("Join Game", systemImage: "person")
                }
                .tint(Color("orange"))
                        /*NavigationLink (destination: ScoreGameView()){
                        Label("Score Game", systemImage: "person.3")
                    }*/
                    NavigationLink (destination: StartGameView()){
                        Label("Start Game", systemImage: "person.3")
                    }
                    .tint(Color("poppy"))
                    //.border(40)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .font(.headline)
            .padding(.bottom, 60)
            .foregroundColor(.black)
            /*Divider()
            NavigationLink (destination: LocalGameView()){
                Label("Local Game", systemImage: "")
            }*/
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                        
                    }) {
                        Image(systemName: "person.crop.circle.fill")
                            .foregroundColor(Color("buttercup"))

                    }
                }
            
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        do {
                            try Auth.auth().signOut()
                        } catch let signOutError as NSError {
                          print("Error signing out: %@", signOutError)
                        }
                        
                        if Auth.auth().currentUser == nil {
                            signedOut = true
                        }
                    }) {
                        //Image(systemName: "line.3.horizontal.circle")
                        Text("Sign Out")
                        .foregroundColor(Color("buttercup"))
                    }
                }
                
            }
            
        }
        .onAppear{
            let user = Auth.auth().currentUser
            let db = Firestore.firestore()
            var id = ""
            if let user = user{
                playerName = user.displayName ?? ""
                id = user.uid
            }
            //playerTheme = db.getTheme()

                let docRef = db.collection("Users").document(id)

                docRef.getDocument { (document, error) in
                    guard error == nil else {
                        //playerTheme = error?.localizedDescription as? String ?? "dshfhfh"
                        return
                    }
                    //playerTheme = "this"
                    if let document = document, document.exists {
                        //playerTheme = "this?"
                        let data = document.data()
                        if let data = data {
                            print("data", data)
                            playerTheme = data["Theme"] as? String ?? ""
                        }
                    }

                }
            
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
                
                join = true
                    
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
                game.players.append(Game.Player(name: playerName, theme: playerTheme))
                game.numPlayers+=1
                start = true
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
