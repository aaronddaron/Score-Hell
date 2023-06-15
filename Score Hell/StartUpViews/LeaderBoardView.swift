//
//  LeaderBoardView.swift
//  Score Hell
//
//  Created by Aaron Geist on 6/8/23.
//

import SwiftUI

struct LeaderBoardView: View {
    let users: [User]
    let account: User
    @State var emptyText = ""
    var body: some View {
        VStack{
            ListUserView(user: account)
                .cornerRadius(10)
                .padding()
                .frame(maxHeight: 100)
                
            Divider()
            Spacer()
            ScrollView(.vertical, showsIndicators: true){
                ForEach(users) { user in
                    VStack{
                        ListUserView(user: user)
                            .cornerRadius(10)
                            .frame(maxHeight: 100)
                    }
                    .padding(.horizontal)
                }
            }
            Spacer()
            VStack{
                Divider()
                Text("")
                        
                    TextField("Player:", text: $emptyText)
                        .padding(.horizontal)
                        .padding(.horizontal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                       
                
                Text("")
                Divider()
            }
            .background(Color("buttercup"))
        }
        
        
    }
    
}

struct LeaderBoardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderBoardView(users: [], account: User(name: "", theme: "", leaderFirst: true, pts: 0, wins: 0, place: 0))
    }
}
