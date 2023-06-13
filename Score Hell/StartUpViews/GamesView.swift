//
//  GamesView.swift
//  Score Hell
//
//  Created by Aaron Geist on 6/12/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct GamesView: View {
    @Binding var game: Game
    @Binding var signedOut: Bool
    @Binding var user: User
    @FocusState private var hideStart: Bool
    @State private var roomCode = ""
    @State private var showingProfile = false
    @State private var playerPts = 0
    @State var newTheme = ""
    @State var newName = ""
    @State var newLeaderFirst = true
    @State private var games: [GameData] = []
    
    
    var body: some View {
        VStack {
            VStack{
                HStack{
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
                        .foregroundColor(.black)
                }
                .padding(.leading)
            
                Spacer()
                
                    Button(action: {
                        showingProfile = true
                    }) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.black)
                        
                    }
                    .padding(.trailing)
                }
                .font(.title3)
                HStack{
                    Text("\(user.name) - \(user.pts)")
                        .padding(.vertical)
                }
                Divider()
            }
            
            Spacer()
            ScrollView(.vertical, showsIndicators: true){
                Button(action: {
                    if roomCode.isEmpty {
                
                        game.socket.connect(withPayload: ["username": user.name, "theme": user.theme])
                           
                
                    }
                }) {
                    NewGameView(playerTheme: $user.theme)
                        .cornerRadius(10)
                        .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.blue, lineWidth: 4)
                            )
                        .padding([.top, .horizontal])
                }
                .foregroundColor(.black)
                
                                    
                ForEach(games){game in
                    VStack {
                        ListGameView(game: game, playerTheme: $user.theme)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                }
            }
        
            Spacer()
            
            VStack{
                Divider()
                Text("")
                HStack{
                        
                    TextField("Room Code:", text: $roomCode)
                        .submitLabel(.join)
                        .focused(withAnimation{ $hideStart})
                        .padding(.horizontal)
                        .padding(.horizontal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                }
                Text("")
                Divider()
            }
            .background(Color("buttercup"))
            .sheet(isPresented: $showingProfile) {
                NavigationStack{
                    ProfileView(newTheme: $newTheme, newName: $newName, newLeaderFirst: $newLeaderFirst)
                        .environmentObject(user)
                    .toolbar{
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                showingProfile = false
                               
                                let db = Database()
                                if !newTheme.isEmpty && newTheme != user.theme{
                                    db.changeTheme(playerTheme: newTheme)
                                    //user.theme = newTheme
                                }
                                if newLeaderFirst != user.leaderFirst{
                                    db.changeLeaderFirst(leaderFirst: newLeaderFirst)
                                    //user.leaderFirst = newLeaderFirst
                                
                                }
                                if !newName.isEmpty && newName != user.name{
                                    db.changeName(playerName: newName)
                                    //user.name = newName
                                }
                            }
                            .tint(Color(newTheme))
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
       
        .onSubmit {
            if roomCode.count == 4 {
                game.socket.connect(withPayload: ["username": user.name, "theme": user.theme, "code": roomCode])
            }
        }
        .onTapGesture {
            let resign = #selector(UIResponder.resignFirstResponder)
            UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
        }
        
        .onAppear{
            game.socket.on("N/A") { data, ack in
                game.socket.disconnect()
            }
            
            let account = Auth.auth().currentUser
            let db = Firestore.firestore()
            var id = ""

            if let account = account{
                id = account.uid
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
                        user.theme = data["theme"] as? String ?? ""
                        user.leaderFirst = data["leaderFirst"] as? Bool ?? true
                        user.name = data["name"] as? String ?? ""
                        user.pts = data["pts"] as? Int ?? 0
                    }
                
                
                
                db.collection("Users").document(id).collection("Games").order(by: "date", descending: true)/*.limit(to: 10)*/
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
        }
    }
}

struct GamesView_Previews: PreviewProvider {
    static var previews: some View {
        GamesView(game: .constant(Game.sampleData), signedOut: .constant(false), user: .constant(User(name: "Aaron", theme: "lavender", leaderFirst: true, pts: 0)))
    }
}
