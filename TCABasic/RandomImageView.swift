//
//  RandomImageView.swift
//  TCABasic
//
//  Created by 변정훈 on 4/29/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct RandomFeature {
    @ObservableState
    struct State {
        var imageUrl: URL = URL(string: "https://picsum.photos/id/237/200/300")!
    }
    
    enum Action {
        case loadButtonTapped
        case imageLoad(URL)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loadButtonTapped:
                let num = Int.random(in: 0...300)
                let url = URL(string: "https://picsum.photos/id/\(num)/200/300")!
                return .run { send in
                    try await Task.sleep(for: .seconds(1))
                    await send(.imageLoad(url))
                }
            case .imageLoad(let url):
                state.imageUrl = url
                return .none
            }
        }
    }
}

struct RandomImageView: View {
    
    var store: StoreOf<RandomFeature>
    
    var body: some View {
        VStack {
            Photo(url: store.imageUrl)
            Button("Random Image") {
                store.send(.loadButtonTapped)
            }
        }
    }
}

extension RandomImageView {
    func Photo(url: URL) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                Rectangle()
                    .fill(.gray)
                    .frame(width: 200, height: 200)
            case .success(let image):
                image.resizable()
                    .resizable()
                    .frame(width: 200, height: 200)
            case .failure:
                Rectangle()
                    .fill(.gray)
                    .frame(width: 200, height: 200)
            @unknown default:
                EmptyView()
            }
        }
    }
}

#Preview {
    RandomImageView(store: Store(initialState: RandomFeature.State(), reducer: { RandomFeature() }))
}
