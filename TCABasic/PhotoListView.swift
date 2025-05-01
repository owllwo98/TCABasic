//
//  PhotoListView.swift
//  TCABasic
//
//  Created by 변정훈 on 4/29/25.
//

import SwiftUI
import ComposableArchitecture

/*
 
 Reducer 에 필요한 의존성들을 간결하게 주입하는 방법을 제공해주는 것 뿐
 DependencyValue
 DependencyKey
 @Dependency
 
 */

struct PicsumImage: Equatable, Identifiable, Decodable {
    let id: String
    let author: String
    let downloadUrl: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case author
        case downloadUrl = "download_url"
    }
}

struct NetworkManager {
    
    private init() { }
    
    func callRequest() async throws -> [PicsumImage] {
        let urlString = "https://picsum.photos/v2/list?page=2&limit=100"
        
        let url = URL(string: urlString)!
        
        let (data, response) =  try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        
        let result = try decoder.decode([PicsumImage].self, from: data)
        return result
    }
}

// 표준 인터페이스 제공 (라이브, 테스트, 모킹 등)
extension NetworkManager: DependencyKey {
    // 실서버 테스트
    static let liveValue = NetworkManager()
}

// DependencyValues 에 networkManager 키 등록
// networkManager 를 통해 객체를 저장하고나 읽어올 수 있고,
// 같은 키(networkManager) 로 라이브, 테스트, 모킹 등을 쉽게 변경할 수 있음
extension DependencyValues {
    var networkManager: NetworkManager {
        get {
            self[NetworkManager.self]
        }
        set {
            self[NetworkManager.self] = newValue
        }
    }
}


@Reducer
struct PhotoListFeature {
    @ObservableState
    struct State {
        var test: [PicsumImage] = []
        var isLoading: Bool = false
    }
    
    enum Action {
        case loadButtonTapped
        case loadSucceed([PicsumImage])
        case loadFailed
    }
    
    // Reducer 에게 필요한 의존성을 간결하게 주입받을 수 있는 방법을 제공
    // @Dependency 매크로는 TCA 가 자동으로 DependencyValues 에서 해당 키를 찾아서 주입해줌
    @Dependency(\.networkManager) var networkManager
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loadButtonTapped:
                
                state.isLoading = true
                
                return .run { send in
                    do {
                        let result = try await networkManager.callRequest()
                        await send(.loadSucceed(result))
                    } catch {
                        await send(.loadFailed)
                    }
                    
                }
            case .loadSucceed(let result):
                state.test = result
                state.isLoading = false
                return .none
            case .loadFailed:
                state.test = []
                state.isLoading = false
                return .none
            }
        }
    }
}


struct PhotoListView: View {
    
    var store: StoreOf<PhotoListFeature>
    
    var body: some View {
        VStack {
            Button("이미지 조회하기") {
                store.send(.loadButtonTapped)
            }
            if store.isLoading {
                ProgressView()
            }
            List(store.test, id: \.id) { item in
                HStack {
                    Photo(url: item.downloadUrl)
                    Text(item.author)
                }
            }
        }
    }
}

extension PhotoListView {
    func Photo(url: URL) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                Rectangle()
                    .fill(.gray)
                    .frame(width: 50, height: 50)
            case .success(let image):
                image.resizable()
                    .resizable()
                    .frame(width: 50, height: 50)
            case .failure:
                Rectangle()
                    .fill(.gray)
                    .frame(width: 50, height: 50)
            @unknown default:
                EmptyView()
            }
        }
    }
}

#Preview {
    PhotoListView(store: Store(initialState: PhotoListFeature.State(), reducer: {
        PhotoListFeature()
    }, withDependencies: {
        $0.networkManager = NetworkManager.liveValue
    })
    )
}
