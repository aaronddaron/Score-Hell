//
//  GameHeaderView.swift
//  Score Hell
//
//  Created by Aaron Geist on 6/1/23.
//

import SwiftUI

struct GameHeaderView: View {
    @Binding var game: Game
    @State var playerName: String
    @State var playerTheme: String
    @State private var showingFullScore = false
    
    var body: some View {
        VStack {
            HStack{
                Text("Round \(game.round)")
                Spacer()
                Text("\(game.numCards) cards")
            }
            .font(.largeTitle)
            HStack {
                Text(playerName)
                .padding(.horizontal)
                .background(Color(playerTheme))
                .cornerRadius(10)
                .font(.title2)
                .foregroundColor(.black)
                
                Spacer()
                                           
                Button(action: { showingFullScore = true }) {
                    Text("Full Score")
                }
                .sheet(isPresented: $showingFullScore) {
                    NavigationStack{
                        FullScoreView(game: $game)
                        .toolbar{
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Done") {
                                    showingFullScore = false
                                        
                                }
                            }
                        }
                    }
                }
            }
            .font(.title2)
        }
        .padding(.horizontal)
    }
}

struct GameHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        GameHeaderView(game: .constant(Game.sampleData), playerName: "Aaron", playerTheme: "lavender")
    }
}
