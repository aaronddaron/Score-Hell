//
//  FinishGameView.swift
//  Score Hell
//
//  Created by Aaron Geist on 5/31/23.
//

import SwiftUI

struct FinishGameView: View {
    @Binding var game: Game
    //game.players[0].winner = true
    var body: some View {
        List{
            HStack{
                Spacer()
                Text("Congrats!")
                Spacer()
            }
           
            ForEach (game.players) { player in
                if player.winner {
                    HStack{
                        Text("\(player.name)")
                        Spacer()
                        Image(systemName: "crown")
                        Text("\(player.score)")
                    }
                    .foregroundColor(.black)
                }
            }
            
            HStack{
                Spacer()
                Text("You Won!")
                Spacer()
            }
            
            ForEach (game.players) { player in
                if !player.winner {
                    HStack{
                        Text("\(player.name)")

                        Spacer()
                        Text("\(player.score)")

                        //Image(systemName: "flame")
                    }
                    .foregroundColor(.black)
                    .listRowBackground(Color(player.theme))
                }
            }

            HStack{
                Spacer()
                Text("Also Played...")
                Spacer()
            }
               
        }
        .font(.title)
        .navigationBarBackButtonHidden(true)
        .onAppear{
            game.socket.emit("finish")
        }
    }
}

struct FinishGameView_Previews: PreviewProvider {
    static var previews: some View {
        FinishGameView(game: .constant(Game.sampleData))
    }
}
