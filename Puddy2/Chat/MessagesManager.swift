//
//  MessagesManager.swift
//  Puddy2
//
//  Created by iMacBig03 on 4/11/23.
//

import Foundation

class MessagesManager: ObservableObject {
    @Published var showWaitingBubble = false
    @Published private(set) var messages: [Message] = []
    @Published private(set) var lastMessageId: String = ""
    
        init() {
            fetchMessages()
        }
        func fetchMessages() {
            // Define some static messages for preview
            let messages: [Message] = [
                Message(id: "1", text: "Hello, I am Puddy, your AI health assistant! Please tell me your current concerns!", isUser: false, timestamp: Date()),
            ]
            self.messages = messages
            self.lastMessageId = messages.last?.id ?? ""
        }
    func setShowingBubble(bool: Bool){
        showWaitingBubble = bool;
    }
//w
    func sendMessage(text: String, username: String) {
        self.setShowingBubble(bool: true)
        let message = Message(
            id: UUID().uuidString,
            text: text,
            isUser: true,
            timestamp: Date())
        self.messages.append(message)
        self.lastMessageId = message.id
        
        guard let url = URL(string: "https://health.northernhorizon.org/chat") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let messageData = ["user_input": text, "username": username]
        
        guard let messageDataJson = try? JSONSerialization.data(withJSONObject: messageData) else {
            return
        }
        
        request.httpBody = messageDataJson
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.uploadTask(with: request, from: request.httpBody) { data, response, error in
            guard error == nil else {
                let errorMessage = "Error: \(error!.localizedDescription) Please try again shortly."
                DispatchQueue.main.async {
                    let newMessage = Message(
                        id: UUID().uuidString,
                        text: errorMessage,
                        isUser: false,
                        timestamp: Date())
                    self.messages.append(newMessage)
                    self.lastMessageId = newMessage.id
                    self.showWaitingBubble = false
                }
                return
            }
            
            guard let data = data else {
                let newMessage = Message(
                    id: UUID().uuidString,
                    text: "No data received",
                    isUser: false,
                    timestamp: Date())
                DispatchQueue.main.async {
                    self.messages.append(newMessage)
                    self.lastMessageId = newMessage.id
                    self.showWaitingBubble = false
                }
                return
            }
            
            if let responseString = String(data: data, encoding: .utf8),
               let json = try? JSONSerialization.jsonObject(with: Data(responseString.utf8), options: []) as? [String: Any],
               let message = json["message"] as? String {
                
                let newMessage = Message(
                    id: UUID().uuidString,
                    text: message == "none" ? "No data received" : message,
                    isUser: false,
                    timestamp: Date())
                
                DispatchQueue.main.async {
                    self.messages.append(newMessage)
                    self.lastMessageId = newMessage.id
                    self.showWaitingBubble = false
                }
            }
        }
        task.resume()
    }

}
struct MessageData: Codable {
    let id: String
    let text: String
    let isUser: Bool
    let timestamp: Date
}
