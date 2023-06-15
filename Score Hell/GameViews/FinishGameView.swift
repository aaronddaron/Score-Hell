//
//  FinishGameView.swift
//  Score Hell
//
//  Created by Aaron Geist on 5/31/23.
//

import SwiftUI

struct FinishGameView: View {
    @Binding var game: Game
    var playerName: String
    var title: String
    
    @State var gameData = GameData(date: "", place: 0, score: 0, made: 0, finished: false, round: 0)

    var body: some View {
        NavigationStack{
            ZStack{
                LinearGradient(
                    colors: [Color("poppy"), Color("buttercup")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                VStack{
                    //List{
                    Spacer()
                        HStack{
                            Spacer()
                            Text("Congrats!")
                            Spacer()
                        }
                       
                        VStack{
                            ForEach (game.players) { player in
                                if player.winner {
                                    VStack{
                                        HStack{
                                            Text("\(player.name)")
                                            Spacer()
                                            Image(systemName: "crown")
                                            Text("\(player.score)")
                                        }
                                        .padding(.horizontal)
                                        HStack{
                                            if player.bidsMade == game.round - 1 && game.round > 1 {
                                                VStack{
                                                    
                                                    Image(systemName: "flame")
                                                    
                                                    Text("")
                                                }
                                            }
                                            VStack{
                                                Image(systemName: "circle.fill")
                                                Text("\(player.bidsMade)") //Bids made
                                            }
                                            
                                            Spacer()
                                            
                                        }
                                        .padding(.horizontal)
                                        .font(.headline)
                                    }
                                    .foregroundColor(.black)
                                    .background(Color(player.theme))
                                }
                            }
                        }
                        .cornerRadius(10)
                        
                        
                        VStack{
                            Divider()
                        }
                        
                        VStack{
                            ForEach (game.players) { player in
                                if !player.winner {
                                    VStack{
                                        HStack{
                                            Text("\(player.name)")
                                            Spacer()
                                            Text("\(player.score)")
                                        }
                                        .padding(.horizontal)
                                        HStack{
                                            if player.bidsMade == game.round - 1 && game.round > 1 {
                                                VStack{
                                                    
                                                    Image(systemName: "flame")
                                                    
                                                    Text("")
                                                }
                                            }
                                            VStack{
                                                Image(systemName: "circle.fill")
                                                Text("\(player.bidsMade)") //Bids made
                                            }
                                            
                                            Spacer()
                                            
                                        }
                                        .padding(.horizontal)
                                        .font(.headline)
                                    }
                                    .foregroundColor(.black)
                                    .background(Color(player.theme))
                                    
                                }
                            }
                        }
                        .cornerRadius(10)
                    
                    
                        HStack{
                            Spacer()
                            Text("...Also Played")
                            Spacer()
                        }
                        .font(.title)
                        
                    //}
                        Spacer()
                        NavigationLink(destination: HomeScreenView()){
                            Text("Home")
                        }
                        .buttonStyle(.borderedProminent)
                        .font(.title3)
                        .tint(Color("poppy"))
                    
                }
                .padding()
                
                
            }
            .font(.title)
            .foregroundColor(.white)
        }
        .navigationBarBackButtonHidden(true)
        
        .onAppear{
            game.socket.emit("finish")
            
            if game.round > 1{
                let db = Database()
                for player in game.players {
                    if player.name == playerName {
                        gameData.score = player.score
                        gameData.made = player.bidsMade
                    }
                }
                
                gameData.place = 1
                for player in game.players {
                    if player.score > gameData.score
                    {
                        gameData.place += 1
                    }
                }
                
                gameData.round = game.round
                if game.round == 14 {
                    gameData.finished = true
                }
                
                
                db.setGameData(game: gameData, title: title)
                
                var points = gameData.made
                if gameData.place == 1{
                    points = points + 10
                }
                
                db.changePts(pts: points)
                
                if gameData.place == 1 {
                    db.incrementWins()
                }
            } 
        }
    }
}

struct FinishGameView_Previews: PreviewProvider {
    static var previews: some View {
        FinishGameView(game: .constant(Game.sampleData), playerName: "Aaron", title: "")
    }
}
