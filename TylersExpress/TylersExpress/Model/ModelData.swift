//
//  ModelData.swift
//  TylersExpress
//
//  Created by Tyler Ashraf on 09/02/2023.
//

import Foundation
import OpenAISwift

struct Message: Identifiable {
    let id = UUID()
    var text: String
    let isFromUser: Bool
    var isResponding: Bool = false

    init(text: String, isFromUser: Bool) {
        self.text = text
        self.isFromUser = isFromUser
    }

    init() {
        self.text = "thinking..."
        self.isFromUser = false
        self.isResponding = true
    }
}

class ModelData: ObservableObject {
    @Published var messages: [Message] = []
    @Published var isTyping: Bool = false
    @Published var modles = [String]()
    @Published var text = ""
    @Published var vm = AppViewModel()
    
    private var client: OpenAISwift?

    func send_stream(_ message: String) {
        // add the message to the list
        messages.append(Message(text: message, isFromUser: true))
        messages.append(Message())
        // send the message to the server

        ChatGPTAPI.shared.stream_chat(message, onDataUpdate: { data in
            _ = self.messages.last!

             DispatchQueue.main.async {
                self.messages[self.messages.count - 1].text = data
                self.messages[self.messages.count - 1].isResponding = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if self.messages.last?.text == data {
                    self.isTyping = false
                }
            }
        })
        // start typing
        isTyping = true
    }

    func createRandomTestMessages() {
        messages = [
            Message(text: "Please log in first.", isFromUser: false)
        ]
    }
    
    func send() {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        modles.append("Me: \(text)")
        vm.send(text: text) {
            response in DispatchQueue.main.async {
                self.modles.append("ChatGpt:"+response)
                self.text = ""
            }
        }
        
    }
        
    func setup() {
        client = OpenAISwift(authToken: "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")
        
    }
}
