//
//  ChatGPTAPI.swift
//  TylersExpress
//
//  Created by Tyler Ashraf on 09/02/2023.
//

import Combine
import Foundation

class ChatGPTAPI {
    static let shared = ChatGPTAPI()
    private var subscriber: AnyCancellable?

    private init() {}

    func stream_chat(_ message: String, onDataUpdate: @escaping (String) -> Void) {
        self.subscriber?.cancel()
        self.subscriber = nil
        send(message)
        let subscriber = ChatGPTWebViewStore.shared.$receivedMsg.sink { newStr in
            onDataUpdate(newStr)
        }
        self.subscriber = subscriber
    }

    func send(_ message: String) {
        let s = "window.sendMsg('\(message)');"
        print("script:", s)
        ChatGPTWebViewStore.shared.webView.evaluateJavaScript(s)
    }
}
