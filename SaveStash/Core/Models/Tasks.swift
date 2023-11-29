//
//  Tasks.swift
//  SaveStash
//
//  Created by Quentin Gaillardet on 27/11/2023.
//

import SwiftData
import SwiftUI


@Model
class Task : Identifiable{
    var id: UUID
    var taskTitle: String
    var creationDate: Date
    var isCompleted: Bool
    var tint: String
    var assignedMember: UUID
    var reward : Int
    var estimatedTime : Int

    init(id: UUID = .init(), taskTitle: String, creationDate: Date = .init(), isCompleted: Bool = false, tint: String,
         assignedMember: UUID = .init(),
         reward: Int = 0, estimatedTime : Int = 3456) {
        self.id = id
        self.taskTitle = taskTitle
        self.creationDate = creationDate
        self.isCompleted = isCompleted
        self.tint = tint
        self.assignedMember = assignedMember
        self.reward = reward
        self.estimatedTime = estimatedTime
    }
    
    var tintColor : Color {
        switch tint {
            case "taskColor1" : return .yellow
            case "taskColor2" : return .green
            case "taskColor3" : return .blue
            case "taskColor4": return .red
            default: return .yellow
        }
        
    }
}
