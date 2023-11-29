//
//  Sidebar.swift
//  SaveStash
//
//  Created by Quentin Gaillardet on 04/11/2023.
//

import SwiftUI

enum Panel: Hashable {
    case home
}


struct Sidebar: View {

    @Binding var selection: Panel?
   
    var body: some View {
        List(selection: $selection) {
            NavigationLink(value: Panel.home) {
                Label("Home", systemImage: "house")
            }
            
           
        }
        .navigationTitle("App")
        #if os(macOS)
        .navigationSplitViewColumnWidth(min: 200, ideal: 200)
        #endif
    }
}

struct Sidebar_Previews: PreviewProvider {
    struct Preview: View {
        @State private var selection: Panel? = Panel.home
        var body: some View {
            Sidebar(selection: $selection)
        }
    }
    
    static var previews: some View {
        NavigationSplitView {
            Preview()
        } detail: {
           Text("Detail!")
        }
    }
}

