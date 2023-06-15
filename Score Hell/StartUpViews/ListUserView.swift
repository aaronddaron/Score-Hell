//
//  ListUserView.swift
//  Score Hell
//
//  Created by Aaron Geist on 6/15/23.
//

import SwiftUI

struct ListUserView: View {
    let user: User
    var body: some View {
        ZStack{
            LinearGradient(
                colors: [Color(user.theme), Color(Theme(name: user.theme).secondary)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            VStack{
                Text("")
                HStack{
                    Text("\(user.place): \(user.name), pts: \(user.pts), wins: \(user.wins)")
                    Spacer()
                }
                .padding(.leading)
                Text("")
            }
        }
    }
}

struct ListUserView_Previews: PreviewProvider {
    static var previews: some View {
        ListUserView(user: User(name: "", theme: "", leaderFirst: true, pts: 0, wins: 0, place: 0))
    }
}
