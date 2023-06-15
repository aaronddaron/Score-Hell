//
//  BidData.swift
//  Score Hell
//
//  Created by Aaron Geist on 6/14/23.
//

import Foundation

struct BidData {
    var bid: Int
    var attempted: Int
    //var round: Int
    var result: String
    //var role: String
    //var numCards: Int
    
    init(bid: Int, attempted: Int, result: String){
        self.bid = bid
        self.attempted = attempted
        //self.round = round
        self.result = result
        //self.role = role
    }
}

extension BidData {
    static let emptyData: BidData = BidData(bid: 0, attempted: 0, result: "")
}
