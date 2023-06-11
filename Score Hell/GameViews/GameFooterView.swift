//
//  GameFooterView.swift
//  Score Hell
//
//  Created by Aaron Geist on 6/1/23.
//

import SwiftUI

struct GameFooterView: View {
    @Binding var game: Game
    let playerName: String
    //let playerTheme: String
    @Binding var userPosition: Int
    var leaderFirst: Bool
    @Binding var deal: Int
    @State private var showingAlert = false
    @State private var alert = ""
    
    @State private var lead = 0
    @State private var date = Date.now
    @State private var title = ""
    @State private var stringDate = ""
    //@State var gameData = GameData(title: "", place: 0, score: 0, made: 0, finished: false, round: 0)
    
    var body: some View {
        
        VStack{
            if !game.started {
                Text("Waiting For Players")
                .font(.title)
            }
            else if game.phase == 1 {
                Text("Playing Round")
                .font(.title)
            }
            else if game.ohellNum < 0 {
                Text("\(game.players[deal].name) can bid anything")
                    .font(.title)
            } else {
                Text("\(game.players[deal].name) cannot bid \(game.ohellNum)")
                    .font(.title)
            }
            
            HStack{
                if !game.started {
                    EditButton()
                }
                //Start Button
                if game.numPlayers >= 2 && !game.started {
                    Button(action: { userPosition = game.setLeader(host: playerName, leaderFirst: leaderFirst)
                        date = Date.now
                        game.started = true
                        deal = game.numPlayers-1
                        
                        if playerName == game.players[lead].name {
                            showingAlert = true
                            alert = "lead"
                        } else if playerName == game.players[deal].name {
                            showingAlert = true
                            alert = "deal"
                        }
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "YYYY-MM-dd-HH"
                        formatter.timeZone = TimeZone(secondsFromGMT: -18000)
                        
                        stringDate = formatter.string(from: date)
                        let db = Database()
                        title = db.createGameData(date: stringDate)
                        
                    }) {
                        Text("Start Game")
                    }
                }
                
                if game.phase == 0 && game.started {
                    Button(action: { game.phase = 1
                        game.socket.emit("play")}) {
                        Text("Play Round")
                        
                    }
                    .disabled(game.bidTotal == game.numCards)
                } else if game.phase == 1{
                    Button(action: {
                        let lastPosition = userPosition
                        userPosition = game.updateGame(host: playerName, leaderFirst: leaderFirst)
                        
                        var role = ""
                        var result = ""
                        if lastPosition == deal {
                            role = "dealer"
                        } else if lastPosition == lead {
                            role = "leader"
                        } else {
                            role = "none"
                        }
                        
                        let t = game.players[lastPosition].tricksTaken
                        let b = game.players[lastPosition].bid
                        
                        if t == b {
                            result = "made"
                        } else if t > b {
                            result = "under"
                        } else {
                            result = "over"
                        }
                        //setBid()
                        let db = Database()
                        db.setBid(bid: b, round: game.round, trick: t, result: result, role: role, title: title)

                        
                        if playerName == game.players[lead].name {
                            showingAlert = true
                            alert = "lead"
                        } else if playerName == game.players[deal].name {
                            showingAlert = true
                            alert = "deal"
                        }
                    }) {
                        Text("Score")
                    }
                    .disabled(game.trickTotal != game.numCards)
                }
                //Finish game Button
                NavigationLink(destination: FinishGameView(game: $game, playerName: playerName, title: title)){
                    Text("End Game")
                }
            }
        }
        .onAppear{
            //deal = game.numPlayers-1
            if !leaderFirst {
                deal = 0
                lead = 1
            }
            
            /*game.socket.on("start") { data, ack -> Void in
                deal = game.numPlayers-1
            }*/
        }
        .buttonStyle(.borderedProminent)
        .tint(Color("orange"))
        .foregroundColor(.black)
        .font(.title3)
        .padding(.bottom)
        .alert("Your \(alert)", isPresented: $showingAlert, actions: {

            Button("Ok", role: .cancel, action: { showingAlert = false})

                })
        
    }
}

struct GameFooterView_Previews: PreviewProvider {
    static var previews: some View {
        GameFooterView(game: .constant(Game.sampleData), playerName: "Aaron", userPosition: .constant(0), leaderFirst: true, deal: .constant(0))
    }
}
