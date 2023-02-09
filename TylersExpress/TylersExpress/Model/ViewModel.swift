//
//  ViewModel.swift
//  TylersExpress
//
//  Created by Tyler Ashraf on 08/02/2023.
//

import SwiftUI
import OpenAISwift

class AppViewModel : ObservableObject {
    
    init() {}
    
    private var client: OpenAISwift?
    
    func setup() {
        client = OpenAISwift(authToken: "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")
        
    }
    func send(text: String, completion: @escaping (String) -> Void){
        client?.sendCompletion(with: text, maxTokens: 500, completionHandler: { result in
            switch result {
            case.success(let model):
                let output = model.choices.first?.text ?? ""
                completion(output)
            case .failure:
                break
            }
        })
        
    }
    
}
