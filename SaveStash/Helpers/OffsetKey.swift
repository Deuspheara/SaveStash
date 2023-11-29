//
//  OffsetKey.swift
//  SaveStash
//
//  Created by Quentin Gaillardet on 25/11/2023.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
