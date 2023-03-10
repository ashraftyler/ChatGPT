//
//  ChatGPTPage.swift
//  TylersExpress
//
//  Created by Tyler Ashraf on 09/02/2023.
//

import SwiftUI

struct ChatGPTPage: View {
    @StateObject var webViewStore = ChatGPTWebViewStore.shared

    var body: some View {
        VStack {
            WebView(webView: webViewStore.webView).onAppear {
                self.webViewStore.webView.load(URLRequest(url: URL(string: "https://chat.openai.com/")!))
            }
        }
    }
}

struct ChatGPTPage_Previews: PreviewProvider {
    static var previews: some View {
        ChatGPTPage()
    }
}
