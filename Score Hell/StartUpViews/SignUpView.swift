//
//  SignUpView.swift
//  Score Hell
//
//  Created by Aaron Geist on 6/7/23.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    
    @State private var playerTheme = "poppy"
    @State var leaderFirst = true
    @State private var playerName = ""
    @State private var message = "Leader shown first"
    @State private var signedUp = false
    @State private var db = Database()
    
    
    var body: some View {
        if signedUp {
            HomeScreenView()
        } else {
            signUp
        }
    }
    
    var signUp: some View {
        NavigationStack{
            ZStack{
                LinearGradient(
                    colors: [Color(playerTheme), Color(Theme(name: playerTheme).secondary)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                VStack{
                    HStack{
                        VStack{
                            TextField("Display Name", text: $playerName)
                                .padding(.horizontal)
                                .padding()
                            Toggle("\(message)", isOn: $leaderFirst)
                                .padding()
                                .tint(Color(Theme(name: playerTheme).secondary))
                                .onChange(of: leaderFirst) {newValue in
                                    if leaderFirst == true {
                                        message = "Leader shown first"
                                    } else {
                                        message = "Dealer shown first"
                                    }
                                }
                        
                        
                        
                        
                            Text("Color")
                            Picker("", selection: $playerTheme) {
                                ForEach(Theme.colors, id: \.self) { color in
                                    ColorView(color: color)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(height: 175)
                            .padding(.horizontal)
                        }
                        
                        
                    }
                    Button("Finish") {
                        
                        /*if let currentUser = Auth.auth().currentUser?.createProfileChangeRequest() {
                            currentUser.displayName = playerName
                            currentUser.commitChanges(completion: {error in
                                if let error = error {
                                    print(error)
                                }
                            })*/
                        db.setPlayer(playerName: playerName, playerTheme: playerTheme, leaderFirst: leaderFirst)

                        signedUp = true
                       // }
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(playerTheme))
                    .padding()
                    .navigationTitle("User Info")
                    
                }
                
            }.foregroundColor(.black)
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
