//
//  DetailTodoView.swift
//  TCABasic
//
//  Created by 변정훈 on 4/24/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct DetailTodoFeature {
    @ObservableState
    struct State {
        var myTodo: MyTodo
    }
    
    enum Action {
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}

struct DetailTodoView: View {
    
    let store: StoreOf<DetailTodoFeature>
    
    var body: some View {
        HStack {
            Image(systemName: store.myTodo.isDone ? "checkmark.circle.fill" : "circle")
            Text(store.myTodo.content)
        }
    }
}

//#Preview {
//    DetailTodoView()
//}
