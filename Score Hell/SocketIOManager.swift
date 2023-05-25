//
//  SocketIOManager.swift
//  Score Hell
//
//  Created by Aaron Geist on 5/25/23.
//

import UIKit
import SocketIO

class SocketIOManager: NSObject {
    static let sharedInstance = SocketManager(socketURL: URL(string: "http://192.168.4.47:3000")!)
    
}

