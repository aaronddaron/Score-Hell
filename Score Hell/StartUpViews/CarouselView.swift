//
//  TabView.swift
//  Score Hell
//
//  Created by Aaron Geist on 6/13/23.
//

import SwiftUI
import Firebase

struct CarouselView: View {
    @State private var playerTheme = ""
    @State private var games: [GameData] = []
    @State private var selectedTab = "one"
    @State private var bidsImage = "chart.bar.doc.horizontal"
    @State private var leaderImage = "crown"
    @State private var homeImage = "house.fill"
    
    var body: some View {
        ZStack{
            LinearGradient(
                colors: [Color("poppy"), Color("buttercup")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            TabView(selection: $selectedTab){
                
                //GamesView(playerTheme: playerTheme, games: games)
                Text("one")
                    .tabItem{
                        //Label("home", systemName: homeImage)
                        Label("",  systemImage: homeImage)
                    }
                    .tag("One")
                /*.onTapGesture {
                 withAnimation{
                 bidsImage = "chart.bar.doc.horizontal"
                 leaderImage = "crown"
                 homeImage = "house.fill"
                 selectedTab = "One"
                 }
                 }
                 */
                
                //BidsView()
                Text("two")
                    .tabItem{
                        Label("",  systemImage: bidsImage)
                    }
                    .tag("Two")
                /*.onTapGesture {
                 withAnimation{
                 bidsImage = "chart.bar.doc.horizontal.fill"
                 leaderImage = "crown"
                 homeImage = "house"
                 selectedTab = "Two"
                 }
                 }
                 */
                
                LeaderBoardView()
                    .tabItem{
                        Label("",  systemImage: leaderImage)
                    }
                    .tag("Three")
                /*.onTapGesture {
                 withAnimation{
                 bidsImage = "chart.bar.doc.horizontal"
                 leaderImage = "crown.fill"
                 homeImage = "house"
                 selectedTab = "Three"
                 }
                 }
                 */
            }
            
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .onAppear{
            let user = Auth.auth().currentUser
            let db = Firestore.firestore()
            var id = ""
            
            if let user = user {
                id = user.uid
            }
            if !id.isEmpty {
                db.collection("Users").document(id).collection("Games").order(by: "date", descending: true).limit(to: 5)
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
            }
        }
    }
        
}

struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselView()
    }
}
