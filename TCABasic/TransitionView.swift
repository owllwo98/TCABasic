//
//  TransitionView.swift
//  TCABasic
//
//  Created by 변정훈 on 4/28/25.
//

import SwiftUI
import ComposableArchitecture

struct TransitionView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

@Reducer
struct DetailTransition {
    @ObservableState
    struct State {
        var field = ""
    }
    
    enum Action: BindableAction {
        case okTap
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .okTap:
                state.field = "as"
                return .none
            case .binding:
                return .none
            }
        }
    }
}


struct DetailTransitionView: View {
    
    @Bindable var store: StoreOf<DetailTransition>
    
    var body: some View {
        VStack {
            Text("텍스트: \(store.field), \(store.field.count)")
//            TextField("입력해주세요", text: $field)
            Button("확인") {
                store.send(.okTap)
            }
        }
        .padding()
        .font(.title)
    }
}

//#Preview {
//    DetailTransitionView(store: Store(initialState: DetailTransition.State()) {
//        DetailTransition()
//    })
//}
