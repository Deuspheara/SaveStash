//
//  DetailColumn.swift
//  SaveStash
//
//  Created by Quentin Gaillardet on 04/11/2023.
//

import SwiftUI

struct DetailColumn: View {
    
    @Binding var selection: Panel?
    
    
    var body: some View {
        switch selection ?? .home {
        case .home:
            HomeView()
        }
    }
}

struct DetailColumn_Previews: PreviewProvider {
    struct Preview: View {
        @State private var selection: Panel? = .home
       
        var body: some View {
            DetailColumn(selection: $selection)
        }
    }
    static var previews: some View {
        Preview()
    }
}
