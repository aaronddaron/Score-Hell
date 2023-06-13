//
//  NewGameView.swift
//  Score Hell
//
//  Created by Aaron Geist on 6/13/23.
//

import SwiftUI

struct NewGameView: View {
    @Binding var playerTheme: String
    //@Binding var game: Game
    //let roomCode: String
    var body: some View {
        ZStack{
            LinearGradient(
                colors: [Color(playerTheme), Color(Theme(name: playerTheme).secondary)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            HStack {
                VStack(alignment: .leading) {
                    Text("New Game")
                    Image(systemName: "arrowtriangle.right.fill")
                    HStack{
                        Text("0")
                        Text("0")
                        Text("0")
                        
                    }
                }
                Spacer()
            }
            .padding(.leading)
            .font(.title2)
               
        }
    }
}

struct NewGameView_Previews: PreviewProvider {
    static var previews: some View {
        NewGameView(playerTheme: .constant("lavender"))
    }
}
