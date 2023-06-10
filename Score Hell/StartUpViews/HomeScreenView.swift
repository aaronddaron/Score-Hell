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
    @State private var games: [GameData] = []
    @State private var playerName = ""
    @State private var playerTheme = ""
    @State private var roomCode = ""
    @State private var userPosition = 0
    @State private var signedOut = false
    @State private var join = false
    @State private var start = false
    @State private var showingProfile = false
    @State var leaderFirst = true
    @State var newTheme = ""
    @State var newName = ""
    @State var newLeaderFirst = true
    
    var body: some View {
        if signedOut {
            LoginView()
        } else if join {
            PlayView(game: $game, playerName: playerName, playerTheme: playerTheme, roomCode: roomCode, userPosition: userPosition, leaderFirst: leaderFirst)
        } else if start {
            HostView(game: $game, playerName: playerName, playerTheme: playerTheme, leaderFirst: leaderFirst, roomCode: roomCode)
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
                    Text("Score Hell")
                    .font(.largeTitle)
                    .foregroundColor(Color("buttercup"))
                    Text(playerName)
                    Text(playerTheme)
                    //Text(playerPts)
                    Spacer()
                
                    TabView{
                        if !games.isEmpty{
                            ScrollView(.vertical, showsIndicators: false){
                                ForEach(games){game in
                                    VStack {
                                        ListGameView(game: game, playerTheme: playerTheme)
                                            .cornerRadius(10)
                                    }
                                    .padding(.horizontal)
                                    
                                }
                            }
                        } else { Text("No games played yet")}
                        BidsView()
                        LeaderBoardView()
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    
                    Button("Join Game") {
                        game.socket.connect(withPayload: ["username": playerName, "theme": playerTheme, "code": roomCode])
                    }
                    .tint(Color("orange"))
                    
                            
                    Button("Start Game"){
                        game.socket.connect(withPayload: ["username": playerName, "theme": playerTheme])
                    }
                        .tint(Color("poppy"))
                    
                    TextField("Room Code:", text: $roomCode)
                        .padding(.horizontal, 100)
                    Divider()
                        .padding(.horizontal, 100)
                    
                        
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .font(.headline)
                .padding(.bottom, 60)
                .foregroundColor(.black)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading){
                        Button(action: {
                            showingProfile = true
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
                            Text("Sign Out")
                            .foregroundColor(Color("buttercup"))
                        }
                    }
                    
                }
            }
            .sheet(isPresented: $showingProfile) {
                NavigationStack{
                    ProfileView(playerTheme: $playerTheme, playerName: $playerName, leaderFirst: $leaderFirst, newTheme: $newTheme, newName: $newName, newLeaderFirst: $newLeaderFirst)
                    .toolbar{
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                showingProfile = false
                                if !newName.isEmpty && newName != playerName{
                                    if let currentUser = Auth.auth().currentUser?.createProfileChangeRequest() {
                                        currentUser.displayName = newName
                                        currentUser.commitChanges(completion: {error in
                                            if let error = error {
                                                print(error)
                                            }
                                        })

                                    }
                                    playerName = newName
                                }
                                let db = Database()
                                if !newTheme.isEmpty && newTheme != playerTheme{
                                    db.changeTheme(playerTheme: newTheme)
                                }
                                if newLeaderFirst != leaderFirst
                                {
                                    db.changeLeaderFirst(leaderFirst: newLeaderFirst)
                                
                                }
                            }
                            .tint(Color("orange"))
                            .buttonStyle(.borderedProminent)
                            .foregroundColor(.black)
                        }
                        
                        ToolbarItem(placement: .principal) {
                            Text("Preferences")
                                .font(.title)
                        }
                        
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                showingProfile = false
                                    
                            }
                            .tint(.black)
                        }
                    }
                }
            }
            
        }
        .onAppear{
            let user = Auth.auth().currentUser
            let db = Firestore.firestore()
            var id = ""
            // timestamp = NSDate().timeIntervalSince1970
            //let myTimeInterval = TimeInterval(timestamp)
            //time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))

            if let user = user{
                playerName = user.displayName ?? ""
                id = user.uid
            }
            //playerTheme = db.getTheme()
            if !id.isEmpty {
                db.collection("Users").document(id)
                    .addSnapshotListener { documentSnapshot, error in
                      guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                      }
                      guard let data = document.data() else {
                        print("Document data was empty.")
                        return
                      }
                      print("Current data: \(data)")
                    playerTheme = data["theme"] as? String ?? ""
                    leaderFirst = data["leaderFirst"] as? Bool ?? true
                    }
                
                
                
                db.collection("Users").document(id).collection("Games").limit(to: 5).order(by: "date", descending: true)
                    .addSnapshotListener { collectionSnapshot, error in
                      guard let collection = collectionSnapshot?.documents else {
                        print("Error fetching collection: \(error!)")
                        return
                      }
                        for doc in collection {
                            let field = doc.data()
                            let date = field["date"] as? String ?? ""
                            let place = field["place"] as? Int ?? 0
                            let score = field["score"] as? Int ?? 0
                            let made = field["bids_made"] as? Int ?? 0
                            let round = field["round"] as? Int ?? 0
                            let finished = field["finished"] as? Bool ?? false
                            games.append(GameData(date: date, place: place, score: score, made: made, finished: finished, round: round))
                        }
                    }
                //let ref = db.collection("Users/").getDocuments()
            }
            
            game.socket.on("players") { data, ack -> Void in
                    let names = data[0] as! [String]
                    let themes = data[1] as! [String]
                    
                    game.numPlayers = names.count
                    game.players.removeAll()
                    //userPosition = game.numPlayers-1
                    for num in 0...game.numPlayers-1 {
                        game.players.append(Game.Player(name: names[num], theme: themes[num]))
                        
                        //game.numPlayers+=1
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
                if !start {
                    join = true
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
