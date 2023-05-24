//
//  ColorView.swift
//  Score Hell
//
//  Created by Aaron Geist on 5/23/23.
//

import SwiftUI

struct ColorView: View {
    var color: String
    var check: Bool
    var body: some View {
        HStack{
            Rectangle()
                .fill(Color(color))
                .frame(maxWidth: 20, maxHeight: 20)
            Text(color)
            Spacer()
            if check == true { Image(systemName: "checkmark") }
        }
        
    }
}

struct ColorView_Previews: PreviewProvider {
    static var previews: some View {
        ColorView(color: Game.sampleData.themes[0].name, check: true)
    }
}
