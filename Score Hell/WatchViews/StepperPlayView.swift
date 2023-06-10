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
    
    var body: some View {
        HStack{
            if game.phase == 0 && game.started{
                Stepper{Text("Bid: \(game.players[i].bid)")} onIncrement: {
                    game.players[i].bid += 1
                    if game.players[i].bid > game.numCards {
                        game.players[i].bid = 0
                        game.bidTotal -= game.numCards
                    } else {
                        game.bidTotal += 1
                    }
                    
                    if game.players[i].name != game.players[deal].name {
                        game.calcOhellNum()
                    }
                    game.socket.emit("bid", game.players[i].name, game.players[i].bid, game.ohellNum, game.bidTotal)
                    
                } onDecrement: {
                    game.players[i].bid -= 1
                    if game.players[i].bid  < 0 {
                        game.players[i].bid = game.numCards
                        game.bidTotal += game.numCards
                    } else {
                        game.bidTotal -= 1
                    }
                    
                    if game.players[i].name != game.players[deal].name {
                        game.calcOhellNum()
                    }
                    game.socket.emit("bid", game.players[i].name, game.players[i].bid, game.ohellNum, game.bidTotal)
                }
            }
            else if game.phase == 1 {
                Stepper{Text("Trick: \(game.players[i].tricksTaken), Total: \(game.trickTotal)")} onIncrement: {
                    
                    game.players[i].tricksTaken += 1
                    
                    if game.players[i].tricksTaken > game.numCards {
                        game.players[i].tricksTaken = 0
                        game.trickTotal -= game.numCards
                    } else {
                        game.trickTotal += 1
                    }
                    game.socket.emit("trick", game.players[i].name, game.players[i].tricksTaken, game.trickTotal)
                    
                } onDecrement: {
                    
                    game.players[i].tricksTaken -= 1
                    
                    if game.players[i].tricksTaken  < 0 {
                        game.players[i].tricksTaken = game.numCards
                        game.trickTotal += game.numCards
                    } else {
                        game.trickTotal -= 1
                    }
                    game.socket.emit("trick", game.players[i].name, game.players[i].tricksTaken, game.trickTotal)
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
