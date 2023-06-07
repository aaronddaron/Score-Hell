//
//  StatsView.swift
//  Score Hell
//
//  Created by Aaron Geist on 6/1/23.
//

import SwiftUI

struct StatsView: View {
    @Binding var player: Game.Player
    @Binding var game: Game
    var body: some View {
        HStack{
            if player.bidsMade == game.round - 1 && game.round > 1 {
                Image(systemName: "flame")
            }
            Image(systemName: "circle.fill")
            Text("\(player.bidsMade)")
            
            Spacer()
        }
        .foregroundColor(.black)
        .font(.headline)
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView(player: .constant(Game.sampleData.players[0]), game: .constant(Game.sampleData))
    }
}
