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
            ZStack{
                LinearGradient(
                    colors: [Color("poppy"), Color("buttercup")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                VStack{
                    Text("Score Hell")
                        .font(.title)
                        .foregroundColor(Color("buttercup"))
                    Spacer()
                    VStack{
                        
                        
                        TextField("Email:", text: $email)
                            .keyboardType(.emailAddress)
                        Divider()
                        
                        SecureField("Password:", text: $password)
                        Divider()
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
                        //.disabled(password.isEmpty || email.isEmpty)
                        .tint(Color("poppy"))
                        
                        Button("Sign Up"){
                            
                            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                                if error != nil {
                                    print(error!.localizedDescription)
                                } else {
                                    signUp = true
                                }
                            }
                        }
                        //.disabled(password.isEmpty || email.isEmpty)
                        .tint(Color("orange"))
                        
                    }
                    .foregroundColor(.black)
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        //.textFieldStyle(.roundedBorder)
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
