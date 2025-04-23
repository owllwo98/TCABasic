//
//  NameView.swift
//  TCABasic
//
//  Created by 변정훈 on 4/23/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct NameFeature {
    @ObservableState
    struct State { // 앱 상태
        var name = "로맨스"
    }
    
    enum Action {
        case romance
        case thriller
        case family
    }
    
    // 액션에 따라 상태를 어떻게 변경할 지 정의
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .romance:
                state.name = "로맨스"
            case .thriller:
                state.name = "스릴러"
            case .family:
                state.name = "가족"
            }
            return .none
        }
    }
    
}


struct NameView: View {
    
    let store: StoreOf<NameFeature>
    
    var body: some View {
        VStack {
            HStack {
                Button("로맨스") { store.send(.romance) }
                Button("스릴러") { store.send(.thriller) }
                Button("가족") {store.send(.family) }
            }
            .buttonStyle(.borderedProminent)
            Text(store.name)
                .font(.largeTitle)
        }
    }
}

#Preview {
    NameView(store: Store(initialState: NameFeature.State(), reducer: { NameFeature() }))
}
