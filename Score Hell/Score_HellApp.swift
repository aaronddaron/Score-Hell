//
//  Score_HellApp.swift
//  Score Hell
//
//  Created by Aaron Geist on 5/22/23.
//

import SwiftUI

@main
struct Score_HellApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            //GameView(game: $game)
            StartGameView()
        }
    }
}
