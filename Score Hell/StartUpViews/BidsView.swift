//
//  BidsView.swift
//  Score Hell
//
//  Created by Aaron Geist on 6/8/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import Charts


struct BidsView: View {
    @State private var zeroTotal: Double = 0
    @State private var bidTotal: Double = 0
    @State private var totalMade: Double = 0
    @State private var totalAvg: Double = 0
    //@State private var zeroMade: Double = 0
    //@State private var zeroAvg: Double = 0
    
    @State private var totals: [Double] = [0, 0, 0, 0, 0, 0, 0, 0]
    @State private var avgs: [Double] = [0, 0, 0, 0, 0, 0, 0, 0]
    @State private var indeces: [Int] = [0, 1, 2, 3, 4, 5, 6, 7]
    @State private var bids: [BidData] = []
    @State private var rounds: [BidData] = []
    @State private var cards: [BidData] = []
    @State private var roles: [BidData] = []
    @State private var emptyText = ""
    //@State private var attempts: Double = 0
    
    var body: some View {
       
                VStack{
                    HStack{
                        if bidTotal == 1 {
                            Text("Total: \(totalAvg, specifier: "%.2f")% on \(bidTotal, specifier: "%.0f") attempt")
                        } else {
                            Text("Total: \(totalAvg, specifier: "%.2f")% on \(bidTotal, specifier: "%.0f") attempts")
                        }
                    }
                    .font(.title2)
                    Chart {
                                ForEach(bids, id: \.bid) { data in
                                    BarMark(
                                        x: .value("Bid", data.bid),
                                        y: .value("Attempts", data.attempted)
                                    )
                                    .foregroundStyle(by: .value("Result", data.result))
                                }
                            }
                    .chartForegroundStyleScale([
                        "made": .green,
                        "over": .red,
                        "under": .blue
                        ])
                    .padding()
                   
                    VStack{
                        Divider()
                        Text("")
                        HStack{
                                
                            TextField("Room Code:", text: $emptyText)
                                .padding(.horizontal)
                                .padding(.horizontal)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .hidden()
                            Text("Change x axis")
                            Spacer()
                            
                        }
                        Text("")
                        Divider()
                    }
                    .background(Color("buttercup"))
                    
                }
        
        .task{
            bids.removeAll()
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
                    if bidTotal > 0 {
                        totalAvg = (totalMade / bidTotal) * 100
                    }
                } catch {
                    print(error)
                }
                
                for num in 0...7 {
                    var made = 0
                    var over = 0
                    var under = 0
                  
                    
                    let tempMade = db.collectionGroup("Bids").whereField("id", isEqualTo: id ).whereField("bid", isEqualTo: num).whereField("result", isEqualTo: "made").count
                    do {
                        let snapshot = try await tempMade.getAggregation(source: .server)
                        made = snapshot.count as? Int ?? 0
                        bids.append(BidData(bid: num, attempted: made, result: "made"))
                       
                    } catch {
                        print(error)
                    }
                    
                    let tempOver = db.collectionGroup("Bids").whereField("id", isEqualTo: id ).whereField("bid", isEqualTo: num).whereField("result", isEqualTo: "over").count
                    do {
                        let snapshot = try await tempOver.getAggregation(source: .server)
                        over = snapshot.count as? Int ?? 0
                        bids.append(BidData(bid: num, attempted: over, result: "over"))
                        
                    } catch {
                        print(error)
                    }
                    
                    let tempUnder = db.collectionGroup("Bids").whereField("id", isEqualTo: id ).whereField("bid", isEqualTo: num).whereField("result", isEqualTo: "under").count
                    do {
                        let snapshot = try await tempUnder.getAggregation(source: .server)
                        under = snapshot.count as? Int ?? 0
                        bids.append(BidData(bid: num, attempted: under, result: "under"))
                    
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
