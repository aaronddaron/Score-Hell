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
            Spacer()
            
            NavigationLink (destination: JoinGameView()){
                Label("Join Game", systemImage: "person")
            }
            
            Divider()
            HStack{
                NavigationLink (destination: StartGameView()){
                    Label("Score Game", systemImage: "person.3")
                }
                NavigationLink (destination: JoinGameView()){
                    Label("Start Game", systemImage: "person.3")
                }
                
            }
            Divider()
            NavigationLink (destination: LocalGameView()){
                Label("Local Game", systemImage: "")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Image(systemName: "person.crop.circle")
                }
                ToolbarItem(placement: .principal){
                    Text("Score Hell")
                        .font(.title)
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Image(systemName: "line.3.horizontal.circle")
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
