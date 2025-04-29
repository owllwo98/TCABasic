//
//  SimpleView.swift
//  TCABasic
//
//  Created by 변정훈 on 4/29/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SimpleFeature {
    @ObservableState
    struct State {
        var count: Int = 0
        var isProgressing = false
    }
    
    enum Action {
        case plusButtonTapped // 1s wait
        case plusCount // +1
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .plusButtonTapped:
                
                state.isProgressing = true
                
                return .run { send in
                    try await Task.sleep(for: .seconds(1))
                    await send(.plusCount)
                }
            case .plusCount:
                state.count += 1
                state.isProgressing = false
                return .none
            }
        }
    }
 
}

struct SimpleView: View {
    
    var store: StoreOf<SimpleFeature>
    
    var body: some View {
        VStack {
            Text("Count \(store.state.count)")
            if store.isProgressing {
                ProgressView()
            }
            Button("Plus") {
                store.send(.plusButtonTapped)
            }
        }
    }
}

#Preview {
    SimpleView(store: Store(initialState: SimpleFeature.State(), reducer: { SimpleFeature() }))
}
