//
//  ContentView.swift
//  SaveStash
//
//  Created by Quentin Gaillardet on 04/11/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selection: Panel? = Panel.home
    @State private var path = NavigationPath()

    var body: some View {
        WidthThresholdReader(widthThreshold: 520) { proxy in
            if proxy.isCompact{
                HomeView()
            } else {
                NavigationSplitView {
                    Sidebar(selection: $selection)
                } detail: {
                    NavigationStack(path: $path) {
                        DetailColumn(selection: $selection)
                    }
                }
                .onChange(of: selection) { oldState, newState in
                    path.removeLast(path.count)
                }
            }
        }
    }
}

#Preview {
    ContentView()
        
}
