//
//  StepperView.swift
//  Score Hell
//
//  Created by Aaron Geist on 6/1/23.
//

import SwiftUI

struct StepperView: View {
    @Binding var game: Game
    @Binding var player: Game.Player
    
    var body: some View {
        HStack{
            if game.phase == 0 && game.started{
                Stepper{Text("Bid: \(player.bid)")} onIncrement: {
                    player.bid += 1
                    if player.bid > game.numCards {
                        player.bid = 0
                        game.bidTotal -= game.numCards
                    } else {
                        game.bidTotal += 1
                    }
                    
                    if player.name != game.players[game.numPlayers-1].name {
                        game.calcOhellNum()
                    }
                    game.socket.emit("bid", player.name, player.bid, game.ohellNum, game.bidTotal)
                    
                } onDecrement: {
                    player.bid -= 1
                    if player.bid  < 0 {
                        player.bid = game.numCards
                        game.bidTotal += game.numCards
                    } else {
                        game.bidTotal -= 1
                    }
                    
                    if player.name != game.players[game.numPlayers-1].name {
                        game.calcOhellNum()
                    }
                    game.socket.emit("bid", player.name, player.bid, game.ohellNum, game.bidTotal)
                }
            }
            else if game.phase == 1 {
                Stepper{Text("Tricks: \(player.tricksTaken)")} onIncrement: {
                    
                    player.tricksTaken += 1
                    
                    if player.tricksTaken > game.numCards {
                        player.tricksTaken = 0
                        game.trickTotal -= game.numCards
                    } else {
                        game.trickTotal += 1
                    }
                    game.socket.emit("trick", player.name, player.tricksTaken)
                    
                } onDecrement: {
                    
                    player.tricksTaken -= 1
                    
                    if player.tricksTaken  < 0 {
                        player.tricksTaken = game.numCards
                        game.trickTotal += game.numCards
                    } else {
                        game.trickTotal -= 1
                    }
                    game.socket.emit("trick", player.name, player.tricksTaken)
                }
            }
        }
    }
}

struct StepperView_Previews: PreviewProvider {
    static var previews: some View {
        StepperView(game: .constant(Game.sampleData), player: .constant(Game.sampleData.players[0]))
    }
}
