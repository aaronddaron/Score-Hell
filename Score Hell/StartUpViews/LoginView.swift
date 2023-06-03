//
//  LoginView.swift
//  Score Hell
//
//  Created by Aaron Geist on 6/2/23.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack{
            HStack{
                Text("Eamil:")
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
                Button("Login"){}
                Button("Sign Up"){}
            }
        }
        .textFieldStyle(.roundedBorder)
        .padding()
        .buttonStyle(.borderedProminent)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
