//
//  StatsView.swift
//  Score Hell
//
//  Created by Aaron Geist on 6/1/23.
//

import SwiftUI

struct StatsView: View {
    @Binding var player: Game.Player
    var body: some View {
        HStack{
            Image(systemName: "flame")
            Text("\(player.streak)")
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
        StatsView(player: .constant(Game.sampleData.players[0]))
    }
}
