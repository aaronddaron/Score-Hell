//
//  BidsView.swift
//  Score Hell
//
//  Created by Aaron Geist on 6/8/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore


struct BidsView: View {
    @State private var zeroTotal: Double = 0
    @State private var bidTotal: Double = 0
    @State private var totalMade: Double = 0
    @State private var totalAvg: Double = 0
    @State private var zeroMade: Double = 0
    @State private var zeroAvg: Double = 0
    
    @State private var totals: [Double] = [0, 0, 0, 0, 0, 0, 0, 0]
    @State private var avgs: [Double] = [0, 0, 0, 0, 0, 0, 0, 0]
    @State private var indeces: [Int] = [0, 1, 2, 3, 4, 5, 6, 7]
    
    var body: some View {
        NavigationStack{
            //Text("\(idd)")
            HStack{
                VStack{
                    HStack{
                        if bidTotal == 1 {
                            Text("Total: \(totalAvg, specifier: "%.2f")% on \(bidTotal, specifier: "%.0f") attempt")
                        } else {
                            Text("Total: \(totalAvg, specifier: "%.2f")% on \(bidTotal, specifier: "%.0f") attempts")
                        }
                    }
                
                    ForEach (indeces, id: \.self) {index in
                        HStack{
                            if totals[index] == 1 {
                                Text("\(index): \(avgs[index], specifier: "%.2f")% on \(totals[index], specifier: "%.0f") attempt")
                            } else {
                                Text("\(index): \(avgs[index], specifier: "%.2f")% on \(totals[index], specifier: "%.0f") attempts")
                            }
                        }
                    }
                    
                }
            }
            .font(.title2)
        }
        
        .task{
            let user = Auth.auth().currentUser
            let db = Firestore.firestore()
            var id = ""
            if let user = user{
                id = user.uid
            }
            
            if !id.isEmpty {
                
                let total = db.collectionGroup("Bids").whereField("id", isEqualTo: id ).count
                do {
                    let snapshot = try await total.getAggregation(source: .server)
                    bidTotal = snapshot.count as? Double ?? 0.0
                } catch {
                    print(error)
                }
                
                let made = db.collectionGroup("Bids").whereField("id", isEqualTo: id ).whereField("result", isEqualTo: "made").count
                do {
                    let snapshot = try await made.getAggregation(source: .server)
                    totalMade = snapshot.count as? Double ?? 0.0
                    totalAvg = (totalMade / bidTotal) * 100
                } catch {
                    print(error)
                }
                
                for num in 0...7 {
                    let tempTotal = db.collectionGroup("Bids").whereField("id", isEqualTo: id ).whereField("bid", isEqualTo: num).count
                    do {
                        let snapshot = try await tempTotal.getAggregation(source: .server)
                        totals[num] = snapshot.count as? Double ?? 0.0
                    } catch {
                        print(error)
                    }
                    
                    let tempMade = db.collectionGroup("Bids").whereField("id", isEqualTo: id ).whereField("bid", isEqualTo: num).whereField("result", isEqualTo: "made").count
                    do {
                        let snapshot = try await tempMade.getAggregation(source: .server)
                        let made = snapshot.count as? Double ?? 0.0
                        avgs[num] = (made / totals[num]) * 100
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
        
}

struct BidsView_Previews: PreviewProvider {
    static var previews: some View {
        BidsView()
    }
}
