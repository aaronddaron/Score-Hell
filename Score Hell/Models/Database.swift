//
//  Database.swift
//  Score Hell
//
//  Created by Aaron Geist on 6/7/23.
//

import Foundation
import Firebase
import FirebaseFirestore

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
    
    func changePts(pts: Int) {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        
        if let user = user{
            let id = user.uid
            
            if !id.isEmpty {
                db.collection("Users").document(id).updateData(["pts": FieldValue.increment(Int64(pts))])
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
    
    func createGameData(date: String) -> String{
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        var title = ""
        if let user = user{
            let id = user.uid
            
            if !id.isEmpty {
                let ref = db.collection("Users").document(id).collection("Games").document()
                ref.setData([
                    "date": date
                ])
                title = ref.documentID
            }
        }
        return title
    }
                                                                                                     
    
    func setGameData(game: GameData, title: String){
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        
        if let user = user{
            let id = user.uid
            
            if !id.isEmpty {
                db.collection("Users").document(id).collection("Games").document(title).updateData([
                    "score": game.score,
                    "round": game.round,
                    "place": game.place,
                    "finished": game.finished,
                    "bids_made": game.made
                ])
            }
        }
    }
    
        
    func setBid(bid: Int, round: Int, trick: Int, result: String, role: String, title: String){
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
            
        if let user = user{
            let id = user.uid
                
            if !id.isEmpty {
                db.collection("Users").document(id).collection("Games").document(title).collection("Bids").addDocument(data: [
                    "id": id,
                    "bid": bid,
                    "round": round,
                    "trick": trick,
                    "result": result,
                    "role": role
                ])
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
