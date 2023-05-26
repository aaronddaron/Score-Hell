//  SwiftUISocketSample
//
//  Created by Juan Mueller on 1/8/23.
//  For more, visit www.ajourneyforwisdom.com
//

import Foundation
import SocketIO

class ChatClient: NSObject {
    static let shared = ChatClient()

    var manager: SocketManager!
    var socket: SocketIOClient!
    var username: String!

    override init() {
        super.init()

        manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!)
        socket = manager.defaultSocket
    }

    func connect() {
        socket.connect()
    }

    func disconnect() {
        socket.disconnect()
    }

    func sendMessage(_ message: String) {
        socket.emit("sendMessage", message)
    }
    
    func sendUsername(_ username: String) {
        socket.emit("sendUsername", username)
    }

    func receiveMessage(_ completion: @escaping (String, String, UUID) -> Void) {
        socket.on("receiveMessage") { data, _ in
            if let text = data[2] as? String,
               let id = data[0] as? String,
               let username = data[1] as? String {
                completion(username, text, UUID.init(uuidString: id) ?? UUID())
            }
        }
    }
    
    func receiveNewUser(_ completion: @escaping (String, [String:String]) -> Void) {
        socket.on("receiveNewUser") { data, _ in
            if let username = data[0] as? String,
               let users = data[1] as? [String:String] {
                completion(username, users)
            }
        }
    }
}
