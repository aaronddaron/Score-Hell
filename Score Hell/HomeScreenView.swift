//
//  HomeScreenView.swift
//  Score Hell
//
//  Created by Aaron Geist on 5/26/23.
//

import SwiftUI

struct HomeScreenView: View {
    var body: some View {
        NavigationStack{
            NavigationLink (destination: StartGameView()){
                Label("Start Game", systemImage: "person")
            }
            Divider()
            VStack{
                NavigationLink (destination: WatchView(game: .constant(Game.sampleData))){
                    Label("Join Game", systemImage: "person.3")
                }
            }
        }
        //.buttonStyle(.borderedProminent)
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}
