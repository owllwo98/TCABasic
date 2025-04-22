//
//  ContentView.swift
//  TCABasic
//
//  Created by 변정훈 on 4/22/25.
//

import SwiftUI
import ComposableArchitecture

/*
 Reducer: Action 과 State 를 받아 새로운 State 를 계산
 */

@Reducer
struct ContentFeature {
    // SOT
    // 관찰 가능한 상태로 만들어주기
    @ObservableState
    struct State: Equatable {
        var count = 0
    }
    
    enum Action {
        case add
        case minus
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .add:
                state.count += 1
                return .none // 비동기 작업이 없음을 의미
            case .minus:
                state.count -= 1
                return .none
            }
        }
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
    
    @Bindable
    var store: StoreOf<ContentFeature>
    
    var body: some View {
        VStack {
            Text("\(store.count)")
                .font(.largeTitle)
            HStack {
                Button("-") {
                    store.send(.minus)
                }
                
                Button("+") {
                    store.send(.add)
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    ContentView(store: Store(initialState: ContentFeature.State()) {
        ContentFeature()
    })
}
