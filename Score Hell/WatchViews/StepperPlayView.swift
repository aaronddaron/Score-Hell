//
//  StepperPlayView.swift
//  Score Hell
//
//  Created by Aaron Geist on 6/5/23.
//

import SwiftUI

struct StepperPlayView: View {
    @Binding var game: Game
    @Binding var i: Int
    let deal: Int
    @State private var image = "arrow.up.circle"
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                //Bid: \(game.players[i].bid)
                if game.phase == 0 && game.started{
                    HStack{
                        Button(action: {
                            if game.players[i].newBid > -1 {
                                withAnimation{
                                    image = "arrow.up.circle"
                                }
                                
                                game.players[i].bid = game.players[i].newBid
                                game.socket.emit("bid", game.players[i].name, game.players[i].bid, game.ohellNum, game.bidTotal)
                                game.checkBids()
                            }
                        }) {
                            
                                Image(systemName: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                            
                        }
                        .tint(Color("buttercup"))
                        if game.players[i].newBid == -1{
                            Text("Bid: -")
                                .font(.title2)
                        } else {
                            Text("Bid: \(game.players[i].newBid)")
                                .font(.title2)
                        }
                        Stepper{} onIncrement: {
                            withAnimation{
                                image = "arrow.up.circle.fill"
                            }
                            if game.players[i].newBid == -1{
                                game.players[i].newBid += 1

                            } else {
                                
                                game.players[i].newBid += 1
                                if game.players[i].newBid > game.numCards {
                                    game.players[i].newBid = 0
                                    game.bidTotal -= game.numCards
                                } else {
                                    
                                    game.bidTotal += 1
                                }
                                
                                if game.players[i].name != game.players[deal].name {
                                    game.calcOhellNum()
                                }
                            }
                            //game.socket.emit("bid", game.players[i].name, game.players[i].bid, game.ohellNum, game.bidTotal)
                            
                        } onDecrement: {
                            withAnimation{
                                image = "arrow.up.circle.fill"
                            }
                            game.players[i].newBid -= 1
                            if game.players[i].newBid  < 0 {
                                game.players[i].newBid = game.numCards
                                game.bidTotal += game.numCards
                            } else {
                                game.bidTotal -= 1
                            }
                            
                            if game.players[i].name != game.players[deal].name {
                                game.calcOhellNum()
                            }
                            //game.socket.emit("bid", game.players[i].name, game.players[i].bid, game.ohellNum, game.bidTotal)
                        }
                    }
                }
                else if game.phase == 1 {
                    HStack{
                        Stepper{Text("Trick: \(game.players[i].tricksTaken), Total: \(game.trickTotal)").font(.title2)} onIncrement: {
                            
                            if game.players[i].tricksTaken == 0 {
                                image = "arrow.up.circle"
                            }
                            game.players[i].tricksTaken += 1
                            
                            if game.players[i].tricksTaken > game.numCards {
                                game.players[i].tricksTaken = 0
                                game.trickTotal -= game.numCards
                            } else {
                                game.trickTotal += 1
                            }
                        game.socket.emit("trick", game.players[i].name, game.players[i].tricksTaken, game.trickTotal)
                            
                        } onDecrement: {
                            if game.players[i].tricksTaken == 1 {
                                image = "arrow.up.circle"
                            }
                            
                            game.players[i].tricksTaken -= 1
                            
                            if game.players[i].tricksTaken  < 0 {
                                game.players[i].tricksTaken = game.numCards
                                game.trickTotal += game.numCards
                            } else {
                                game.trickTotal -= 1
                            }
                            game.socket.emit("trick", game.players[i].name, game.players[i].tricksTaken, game.trickTotal)
                        }
                        /*Button(action: {
                            game.socket.emit("trick", game.players[i].name, game.players[i].tricksTaken, game.trickTotal)
                        }) {
                            Image(systemName: "arrow.up.circle")
                        }*/
                    }
                }
            }
        }
    }
}

struct StepperPlayView_Previews: PreviewProvider {
    static var previews: some View {
        StepperPlayView(game: .constant(Game.sampleData), i: .constant(0), deal: 0)
    }
}
