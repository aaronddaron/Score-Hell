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
    @State private var signUp = false
    
    var body: some View {
        if loggedIn && signUp{
            SignUpView()
        } else if loggedIn {
            HomeScreenView()
        } else {
            LogIn
        }
    }
    
    var LogIn: some View {
        NavigationStack{
            Text("Score Hell")
                .font(.title)
            Spacer()
            VStack{
                HStack{
                    Text("Email:")
                    Spacer()
                }
                
                TextField("", text: $email)
                HStack{
                    Text("Password:")
                    Spacer()
                }
            
                SecureField("", text: $password)
            }
            .font(.title3)
            .padding()
            HStack{
                Button("Login"){
                    Auth.auth().signIn(withEmail: email, password: password) { result, error in
                        if error != nil {
                            print(error!.localizedDescription)
                        }
                    }
                }
                .disabled(password.isEmpty || email.isEmpty)
                
                Button("Sign Up"){
                    
                    Auth.auth().createUser(withEmail: email, password: password) { result, error in
                        if error != nil {
                            print(error!.localizedDescription)
                        } else {
                            signUp = true
                        }
                    }
                }
                .disabled(password.isEmpty || email.isEmpty)
                
            }
            Spacer()
        }
        .textFieldStyle(.roundedBorder)
        //.padding()
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
