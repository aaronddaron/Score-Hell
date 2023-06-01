//
//  ContentView.swift
//  Score Hell
//
//  Created by Aaron Geist on 5/22/23.
//

import SwiftUI
import SocketIO

struct GameView: View {
    @State var phase = 0
    @Binding var game: Game
    let playerName: String
    let playerTheme: String
    @State var round = 1
    @State private var showingFinish = false
    @State private var showingFullScore = false
    @State private var showingAlert = false
    @State private var alert = ""
    @State private var started = false
    @Binding var names: [String]
    @Binding var themes: [String]
    
    private func updateGame() {
        phase = 0
        for number in 0...game.players.count-1{
            game.players[number].updateScore()
            game.players[number].bid = 0
            game.players[number].newBid = 0
            game.players[number].tricksTaken = 0
            game.players[number].newTricksTaken = 0
           
        }
        if round + 1 == 14 {
            game.bidTotal = game.numCards
        } else {
            game.numCards = game.cards[round]
            round += 1

            game.bidTotal = 0
            game.trickTotal = 0
            game.ohellNum = game.numCards
            
            game.order(leader: 1)
            
            if playerName == game.players[0].name {
                showingAlert = true
                alert = "lead"
            } else if playerName == game.players[game.numPlayers-1].name {
                showingAlert = true
                alert = "deal"
            }
            
            game.socket.emit("nextRound")
            
        }
        game.calcWinner()
    }
    
    var body: some View {
        NavigationStack{
                VStack {
                    VStack {
                        HStack{
                            Text("Round \(round)")
                            Spacer()
                            Text("\(game.cards[round - 1]) cards")
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
                
                    List($game.players) { $player in
                        PlayerView(player: $player, phase: phase, game: $game)
                            .listRowBackground(Color(player.theme))
                    }
                    
                    if game.ohellNum < 0 {
                        Text("\(game.players[game.players.count-1].name) can bid anything")
                            .font(.title3)
                    } else {
                        Text("\(game.players[game.players.count-1].name) cannot bid \(game.ohellNum)")
                            .font(.title3)
                    }
                    
                    HStack{
                        if game.numPlayers > 2 && started == false{
                            Button(action: { game.setLeader()
                                started = true
                                if playerName == game.players[0].name {
                                    showingAlert = true
                                    alert = "lead"
                                } else if playerName == game.players[game.numPlayers-1].name {
                                    showingAlert = true
                                    alert = "deal"
                                }
                            }) {
                                Text("Start Game")
                            }
                            .disabled(game.bidTotal == game.numCards)
                        }
                        if phase == 0 && started == true{
                            Button(action: { phase = 1}) {
                                Text("Play Round")
                            }
                            .disabled(game.bidTotal == game.numCards)
                        } else if phase == 1{
                            Button(action: {
                                if game.trickTotal == game.numCards {
                                    updateGame()
                                }
                            }) {
                                Text("Score")
                            }
                            .disabled(game.trickTotal != game.numCards)
                        }
                        NavigationLink(destination: FinishGameView(game: $game)){
                            Text("End Game")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.title3)
                    .padding(.bottom)
                }
                .navigationBarBackButtonHidden(true)
                .onAppear {
                    game.socket.connect(withPayload: ["username": playerName, "theme": game.players[0].theme, "names": names, "themes": themes])
                    
                    
                    
                    game.socket.on("game"){ (data, ack) -> Void in
                        let bids = data[0] as! [Int]
                        
                        for num in 0...game.players.count-1 {
                            game.players[num].bid = bids[num]
                        }
                        round = data[1] as! Int
                        game.ohellNum = data[2] as! Int
                        started = true
                    }
                    
                    game.socket.on("winners"){ (data, ack) -> Void in
                        let winners = data[0] as! [Bool]
                        for num in 0...game.players.count-1 {
                            game.players[num].winner = winners[num]
                        }
                    }
                    
                    game.socket.on("scores"){ (data, ack) -> Void in
                        let scores = data[0] as! [Int]
                        let streaks = data[1] as! [Int]
                        for num in 0...game.players.count-1 {
                            game.players[num].score = scores[num]
                            game.players[num].streak = streaks[num]
                        }
                    }
                    
                    game.socket.on("players"){ (data, ack) -> Void in
                        let names = data[0] as! [String]
                        let themes = data[1] as! [String]
                        
                        game.players.removeAll()
                        for num in 0...names.count-1 {
                            game.players.append(Game.Player(name: names[num], theme: themes[num]))
                            
                        }
                    }
                    game.socket.on("newPlayer"){ (data, ack) -> Void in
                        let tempName = data[0] as! String
                        let tempTheme = data[1] as! String
                        game.players.append(Game.Player(name: tempName, theme: tempTheme))
                        game.numPlayers+=1
                        
                    }

                }
                .alert("Your \(alert)", isPresented: $showingAlert, actions: {

                    Button("Ok", role: .cancel, action: { showingAlert = false})

                        })
                
            }
    }
}
    
struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(game: .constant(Game.sampleData), playerName: "Aaron", playerTheme: "lavender", names: .constant([]), themes: .constant([]))
    }
}

