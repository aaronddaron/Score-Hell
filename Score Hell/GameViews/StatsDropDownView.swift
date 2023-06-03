//
//  StatsView.swift
//  Score Hell
//
//  Created by Aaron Geist on 6/1/23.
//

import SwiftUI

struct StatsDropDownView: View {
    @Binding var showingStats: Bool
    var body: some View {
        HStack{
        
            Button(action: {
                if showingStats {
                    showingStats = false
                } else {
                    showingStats = true
                }
                
            }) {
                if !showingStats {
                    Image(systemName: "chevron.down")
                } else {
                    Image(systemName: "chevron.up")
                }
            }
            .font(.headline)
            Text("Stats")
                .font(.headline)
            Spacer()
        }
    }
}

struct StatsDropDownView_Previews: PreviewProvider {
    static var previews: some View {
        StatsDropDownView(showingStats: .constant(false))
    }
}
