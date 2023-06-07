//
//  LoginView.swift
//  Score Hell
//
//  Created by Aaron Geist on 6/2/23.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var loggedIn = false
    
    var body: some View {
        if loggedIn {
            HomeScreenView()
        } else {
            LogIn
        }
    }
    
    var LogIn: some View {
        VStack{
            HStack{
                Text("Email:")
                Spacer()
            }
            .font(.title3)
            
            TextField("", text: $email)
            HStack{
                Text("Password:")
                Spacer()
            }
            .font(.title3)
            SecureField("", text: $password)
            HStack{
                Button("Login"){
                    Auth.auth().signIn(withEmail: email, password: password) { result, error in
                        if error != nil {
                            print(error!.localizedDescription)
                        }
                    }
                }
                Button("Sign Up"){
                    Auth.auth().createUser(withEmail: email, password: password) { result, error in
                        if error != nil {
                            print(error!.localizedDescription)
                        }
                    }
                }
            }
        }
        .textFieldStyle(.roundedBorder)
        .padding()
        .buttonStyle(.borderedProminent)
        .onAppear {
            Auth.auth().addStateDidChangeListener { auth, user in
                if user != nil {
                    loggedIn = true
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
