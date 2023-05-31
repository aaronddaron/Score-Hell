//
//  FullScoreView.swift
//  Score Hell
//
//  Created by Aaron Geist on 5/22/23.
//

import SwiftUI

struct FullScoreView: View {
    let currentOrientation = AppDelegate.orientationLock
    @Binding var game: Game
    @State private var orientation = UIDevice.current.orientation
    var body: some View {
        VStack{
            HStack {
                ForEach(game.players){ player in
                    VStack{
                        Text(player.name)
                    }
                }
                .padding(.horizontal, 14)
            }
            List{
                ZStack{
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.black)
                        .frame(maxHeight: .infinity)
                        .ignoresSafeArea()
                    HStack{
                        ForEach(game.players){ player in
                            VStack{
                                Text(player.name)
                                    .hidden()
                                Text("0")

                                ForEach(player.scores) { row in
                                    Text("\(row.sum)")
                                    Divider()
                                    Text("\(row.score)")
                                }
                            }
                            .foregroundColor(Color(player.theme))
                        }
                        .padding(.horizontal, 14)
                    }
                }.onAppear() {
                    AppDelegate.orientationLock = .landscape
                }
                .onDisappear{
                    AppDelegate.orientationLock = currentOrientation
                }
            }
            .scrollContentBackground(.hidden)
        }
        .padding(.top)
    }
}

struct FullScoreView_Previews: PreviewProvider {
    static var previews: some View {
        FullScoreView(game: .constant(Game.sampleData))
    }
}
