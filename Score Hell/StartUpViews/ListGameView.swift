//
//  ListView.swift
//  Score Hell
//
//  Created by Aaron Geist on 6/8/23.
//

import SwiftUI

struct ListGameView: View {
    var game: GameData
    var playerTheme: String
    //@State private var playerSecondary
    var body: some View {
        ZStack{
            LinearGradient(
                colors: [Color(playerTheme), Color(Theme(name: playerTheme).secondary)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            VStack{
                HStack{
                    Text("\(game.title)")
                        .padding(.leading)
                    Spacer()
                }
                Text("")
                HStack{
                    Text("\(game.place)")
                    Text("\(game.score)")
                    Text("\(game.made)")
                    Spacer()
                }
                .padding(.leading)
                
            }
            .font(.title2)
        }
    }
    
}

struct ListGameView_Previews: PreviewProvider {
    
    static var previews: some View {
        //let timestamp = NSDate().timeIntervalSince1970
        ListGameView(game: GameData(title: "timestamp", place: 1, score: 65, made: 7), playerTheme: "lavender")
    }
}