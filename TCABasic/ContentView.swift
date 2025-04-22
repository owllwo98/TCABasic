//
//  ContentView.swift
//  TCABasic
//
//  Created by 변정훈 on 4/22/25.
//

import SwiftUI
import ComposableArchitecture

struct ContentFeature {
    
    struct State: Equatable {
        var count = 0
    }
    
    enum Action {
        case add
        case minus
    }
    
    func reduce(state: inout State, action: Action) {
        switch action {
        case .add:
            state.count += 1
        case .minus:
            state.count -= 1
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Text("0")
                .font(.largeTitle)
            HStack {
                Button("-") {
                    
                }
                
                Button("+") {
                    
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

//#Preview {
//    ContentView()
//}
