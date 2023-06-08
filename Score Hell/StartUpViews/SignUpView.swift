//
//  SignUpView.swift
//  Score Hell
//
//  Created by Aaron Geist on 6/7/23.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    
    @State private var playerTheme = ""
    @State private var playerName = ""
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
            List{
                Section("Display Name"){
                    TextField("Enter Name", text: $playerName)
                }
                Section("Choose Color"){
                    Picker("", selection: $playerTheme) {
                        ForEach(Theme.colors, id: \.self) { color in
                            ColorView(color: color)
                        }
                    }
                    .pickerStyle(.wheel)
                }
            }
            Button("Finish") {
                
                if let currentUser = Auth.auth().currentUser?.createProfileChangeRequest() {
                    currentUser.displayName = playerName
                    currentUser.commitChanges(completion: {error in
                        if let error = error {
                            print(error)
                        }
                    })
                    db.changeTheme(playerTheme: playerTheme)
                    signedUp = true
                }
                
            }
            .buttonStyle(.borderedProminent)
            .padding()
            .navigationTitle("User Info")
        }
        
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
