//
//  TodoView.swift
//  TCABasic
//
//  Created by 변정훈 on 4/23/25.
//

import SwiftUI
import ComposableArchitecture

struct MyTodo: Hashable, Identifiable {
    let id = UUID()
    var content: String
    var isDone: Bool = false
}


@Reducer
struct TodoFeature {
    @ObservableState
    struct State {
        var todoText = ""
        var todoList: IdentifiedArrayOf<MyTodo> = [MyTodo(content: "asa"), MyTodo(content: "asf")]
        
        @Presents var showDetail: DetailTodoFeature.State?
    }
    
    enum Action: BindableAction {
        case add
        case delete(id: MyTodo.ID)
        case done(id: MyTodo.ID)
        // transition
        // @Presents, PresentationAction, ifLet
        case select(id: MyTodo.ID) // 셀 클릭
        case showDetail(PresentationAction<DetailTodoFeature.Action>)
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerOf<Self> {
        
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .add:
                state.todoList.append(MyTodo(content: state.todoText))
            case .delete(let id):
                
                state.todoList.remove(id: id)
            case .done(let id):
                
                guard let idx = state.todoList.index(id: id) else { return .none }
                
                state.todoList[idx].isDone.toggle()
            case .select(let id):
                // 선택했을 때 다음 화면으로 넘어가도록
                // 다음 화면으로 넘어갈 때 MyTodo 값 전달도 되도록
                
                if let list = state.todoList[id: id] {
                    state.showDetail = DetailTodoFeature.State(myTodo: list)
                }
                
                return .none
            case .binding:
                break
            case .showDetail(_):
                return .none
            }
            return .none
        }
        .ifLet(\.$showDetail, action: \.showDetail) {
            DetailTodoFeature()
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
                createList()
            }
            .navigationTitle("나의 할일")
            .navigationDestination(store: store.scope(state: \.$showDetail, action: \.showDetail)) { store in
                DetailTodoView(store: store)
            }
        }
    }
    
    private func createList() -> some View {
        List {
            ForEach(store.todoList, id: \.self) { item in
                HStack {
                    Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                        .onTapGesture {
                            store.send(.done(id: item.id))
                        }
                    Text(item.content)
                        .onTapGesture {
                            store.send(.select(id: item.id))
                        }
                }
                .swipeActions {
                    Button("삭제", role: .destructive) {
                        store.send(.delete(id: item.id))
                    }
                }
            }
        }
    }
}


//#Preview {
//    TodoView(store: Store(initialState: TodoFeature.State(), reducer: { TodoFeature() }))
//}
