//
//  View+Extensions.swift
//  SaveStash
//
//  Created by Quentin Gaillardet on 25/11/2023.
//

import SwiftUI

extension View {
    func isSameDate(_ date1: Date,_ date2: Date) -> Bool {
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }
}
