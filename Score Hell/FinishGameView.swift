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
                    VStack{
                        HStack{
                            
                            Text("\(player.name)")
                            Spacer()
                            Image(systemName: "crown")
                            Text("\(player.score)")
                        }
                        HStack{
                            
                            VStack{
                                Image(systemName: "flame")
                                Text("\(player.streak)") //Longest Streak
                            }
                            VStack{
                                Image(systemName: "circle.fill")
                                Text("\(player.bidsMade)") //Bids made
                            }
                            VStack{
                                Image(systemName: "circle")
                                Text("\(13 - player.bidsMade)") //Bids missed
                            }
                            //Dirty Rat symbol
                            VStack{
                                Image(systemName: "0.square")
                                Text("\(player.bidZero)") //0's bid (and made?)
                            }
                            
                            Spacer()
                            if player.streak == game.round - 1{
                                VStack{
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                        .font(.headline)
                    }
                    .foregroundColor(.black)
                    .listRowBackground(Color(player.theme))
                }
            }
            
            HStack{
                Spacer()
                Text("")
                Spacer()
            }
            
            ForEach (game.players) { player in
                if !player.winner {
                    VStack{
                        HStack{
                            Text("\(player.name)")

                            Spacer()
                            Text("\(player.score)")

                            //Image(systemName: "flame")
                        }
                        HStack{
                            
                            VStack{
                                Image(systemName: "flame")
                                Text("\(player.longestStreak)") //Longest Streak
                            }
                            VStack{
                                Image(systemName: "circle.fill")
                                Text("\(player.bidsMade)") //Bids made
                            }
                            VStack{
                                Image(systemName: "circle")
                                Text("\(13 - player.bidsMade)") //Bids missed
                            }
                            //Dirty Rat symbol
                            VStack{
                                Image(systemName: "0.square")
                                Text("\(player.bidZero)") //0's bid (and made?)
                            }
                            
                            Spacer()
                            if player.streak == game.round-1 {
                                VStack{
                                    Image(systemName: "checkmark")
                                }
                            }
                            
                        }
                        .font(.headline)
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
