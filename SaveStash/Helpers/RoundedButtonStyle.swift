//
//  RoundedButtonStyle.swift
//  SaveStash
//
//  Created by Quentin Gaillardet on 04/11/2023.
//

import Foundation

import SwiftUI

struct RoundedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(4)
            .frame(width: 28, height: 28)
            .background(Color(uiColor: .systemGroupedBackground))
            .cornerRadius(20)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
