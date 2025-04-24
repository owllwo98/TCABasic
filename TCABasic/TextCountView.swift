//
//  TextCountView.swift
//  TCABasic
//
//  Created by 변정훈 on 4/22/25.
//

import SwiftUI
import ComposableArchitecture

struct TextCountView: View {
    
    @Bindable
    var store: StoreOf<TextCountStore> //Store<R.State, R.Action>
    
    var body: some View {
        VStack {
            TextField("텍스트를 입력해주세요.", text: $store.text)
            Text("\(store.text.count)")
        }
    }
}

@Reducer
struct TextCountStore {
    @ObservableState
    struct State: Equatable {
        var text: String = ""
    }
    
    // 필수1. BindableAction
    enum Action: BindableAction {
        case binding(BindingAction<State>)
    }
    // 필수2. BindingReducer()
    var body: some ReducerOf<Self> {
        // 양방향 Binding 을 위해서 text 수정 -> State 반영
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            }
        }
    }
}

//#Preview {
//    TextCountView(
//        store: Store(initialState: TextCountStore.State()) {
//            TextCountStore()
//        }
//    )
//}
