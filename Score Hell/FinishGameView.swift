//
//  FinishGameView.swift
//  Score Hell
//
//  Created by Aaron Geist on 5/23/23.
//

import SwiftUI

struct FinishGameView: View {
    //@State private var newGame = Game(players: [])
    
    var body: some View {
        NavigationLink (destination: StartGameView()){
            Text("New Game")
        }
    }
}

struct FinishGameView_Previews: PreviewProvider {
    static var previews: some View {
        FinishGameView()
    }
}
