//
//  ProfileView.swift
//  Score Hell
//
//  Created by Aaron Geist on 6/8/23.
//

import SwiftUI
import Firebase

struct ProfileView: View {
    @Binding var playerTheme: String
    @Binding var playerName: String
    @Binding var leaderFirst: Bool
    @Binding var newTheme: String
    @Binding var newName: String
    @Binding var newLeaderFirst: Bool
    @State private var message = "Leader shown first"
    @State private var db = Database()
    
    var body: some View {
        NavigationStack{
            ZStack{
                LinearGradient(
                    colors: [Color(newTheme), Color(Theme(name: newTheme).secondary)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                VStack{
                    HStack{
                        VStack{
                            TextField("Display Name", text: $newName)
                                .padding(.horizontal)
                            Divider()
                                .padding()
                            Toggle("\(message)", isOn: $newLeaderFirst)
                                .padding()
                                .tint(Color("poppy"))
                                .onChange(of: newLeaderFirst) {newValue in
                                    if newLeaderFirst == true {
                                        message = "Leader shown first"
                                    } else {
                                        message = "Dealer shown first"
                                    }
                                }
                        
                            Text("Color")
                            Picker("", selection: $newTheme) {
                                ForEach(Theme.colors, id: \.self) { color in
                                    ColorView(color: color)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(height: 175)
                            .padding(.horizontal)
                        }
                        
                        
                    }
                    
                }
                
            }.foregroundColor(.black)
        }
        .onAppear{
            newLeaderFirst = leaderFirst
            newTheme = playerTheme
            
            if newLeaderFirst == true {
                message = "Leader shown first"
            } else {
                message = "Dealer shown first"
            }
        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(playerTheme: .constant("tan"), playerName:  .constant("Aaron"), leaderFirst: .constant(true), newTheme: .constant(""), newName: .constant(""), newLeaderFirst: .constant(true))
    }
}
