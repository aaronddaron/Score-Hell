//
//  Database.swift
//  Score Hell
//
//  Created by Aaron Geist on 6/7/23.
//

import Foundation
import Firebase

class Database {
    
    func setTheme(playerTheme: String) {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        
        if let user = user{
            let id = user.uid
            
            if !id.isEmpty {
                db.collection("Users").document(id).setData(["theme": playerTheme])
            }
        }
    }
    
    func changeTheme(playerTheme: String) {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        
        if let user = user{
            let id = user.uid
            
            if !id.isEmpty {
                db.collection("Users").document(id).updateData(["theme": playerTheme])
            }
        }
    }
    
    func setLeaderFirst(leaderFirst: Bool) {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        
        if let user = user{
            let id = user.uid
            
            if !id.isEmpty {
                db.collection("Users").document(id).setData(["leaderFirst": leaderFirst])
            }
        }
    }
    
    func changeLeaderFirst(leaderFirst: Bool) {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        
        if let user = user{
            let id = user.uid
            
            if !id.isEmpty {
                db.collection("Users").document(id).updateData(["leaderFirst": leaderFirst])
            }
        }
    }
    
    func getTheme() -> String{
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        var id = ""
        var theme = "changePls"
        if let user = user{
            id = user.uid
        }
            let docRef = db.collection("Users").document(id)

            docRef.getDocument { (document, error) in
                guard error == nil else {
                    theme = error?.localizedDescription as? String ?? "dshfhfh"
                    return
                }
                theme = "this"
                if let document = document, document.exists {
                    theme = "this"
                    let data = document.data()
                    if let data = data {
                        print("data", data)
                        theme = "this"//data["Theme"] as? String ?? ""
                    }
                }

            }
        return theme
    }
    
}
