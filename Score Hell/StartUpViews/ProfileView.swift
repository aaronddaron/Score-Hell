//
//  ProfileView.swift
//  Score Hell
//
//  Created by Aaron Geist on 6/8/23.
//

import SwiftUI
import Firebase

struct ProfileView: View {
    @EnvironmentObject var user: User
    @Binding var newTheme: String
    @Binding var newName: String
    @Binding var newLeaderFirst: Bool
    //@State private var message = "Leader shown first"
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
                            
                            TextField("Display Name", text: $newName)
                                .padding(.horizontal)
                            Divider()
                                .padding(.horizontal)
                            Toggle("", isOn: $newLeaderFirst)
                                .padding()
                                .tint(Color(Theme(name: newTheme).secondary))
                        
                            Text("Color")
                            Picker("Leader shown first", selection: $newTheme) {
                                ForEach(Theme.colors, id: \.self) { color in
                                    ColorView(color: color)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(height: 175)
                            .padding(.horizontal)
                        }
                        .font(.title2)
                
            }.foregroundColor(.black)
        }
        .onAppear{
            newLeaderFirst = user.leaderFirst
            newTheme = user.theme
            newName = user.name
            
        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(newTheme: .constant(""), newName: .constant(""), newLeaderFirst: .constant(true))
            .environmentObject(User(name: "Aaron", theme: "lavender", leaderFirst: true, pts: 0))
        
    }
}
