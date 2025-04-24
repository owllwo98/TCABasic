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
        var genreText = ""
    }
    
    // BindableAction 이 가끔 채택되는 이유 >> @State <-> @Binding
    enum Action: BindableAction {
        case romance
        case thriller
        case family
        case binding(BindingAction<State>)
    }
    
    // 액션에 따라 상태를 어떻게 변경할 지 정의
    var body: some ReducerOf<Self> {
        
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .romance:
                state.name = "로맨스"
            case .thriller:
                state.name = "스릴러"
            case .family:
                state.name = "가족"
            case .binding:
                break
            }
            return .none
        }
    }
    
}


struct NameView: View {
    
    @Bindable var store: StoreOf<NameFeature>
    
//    @State private var genreText = ""
    
    var body: some View {
        VStack {
            TextField("장르를 입력해주새요", text: $store.genreText)
            Text("텍스트필드에 입력한 내용: \(store.genreText)")
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
