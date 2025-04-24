//
//  TodoView.swift
//  TCABasic
//
//  Created by 변정훈 on 4/23/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct TodoFeature {
    @ObservableState
    struct State {
        var todoText = ""
        var todoList = ["assa", "sd"]
    }
    
    enum Action: BindableAction {
        case add
        case delete(index: Int)
        case done
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerOf<Self> {
        
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .add:
                state.todoList.append(state.todoText)
            case .delete(let index):
                state.todoList.remove(at: index)
            case .done:
                state.todoText = ""
            case .binding:
                break
            }
            return .none
        }
    }
}

struct TodoView: View {
    
    @Bindable var store: StoreOf<TodoFeature>
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("할일 입력", text: $store.todoText)
                    Button {
                        store.send(.add)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                .padding()
                List {
                    ForEach(Array(store.todoList.enumerated()), id: \.offset) { index, item in
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text(item)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            store.send(.done)
                        }
                        .swipeActions {
                            Button("삭제", role: .destructive) {
                                store.send(.delete(index: index))
                            }
                        }
                    }
                }
            }
            .navigationTitle("나의 할일")
        }
    }
}

#Preview {
    TodoView(store: Store(initialState: TodoFeature.State(), reducer: { TodoFeature() }))
}
