//
//  TCABasicApp.swift
//  TCABasic
//
//  Created by 변정훈 on 4/22/25.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCABasicApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: Store(initialState: ContentFeature.State()){
                ContentFeature()
            })
        }
    }
}
