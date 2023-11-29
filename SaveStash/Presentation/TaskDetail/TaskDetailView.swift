//
//  TaskDetailView.swift
//  SaveStash
//
//  Created by Quentin Gaillardet on 28/11/2023.
//
import SwiftUI

struct TaskDetailView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.presentationMode) var presentationMode

    @State private var isEditing = false
    @State private var editedTaskTitle = ""
    @State var task: Task
    @State private var editedEstimatedTimeDays = 0
    @State private var editedEstimatedTimeMinutes = 0
    @State private var editedEstimatedTimeSeconds = 0
    @State private var editedReward = 0
    @State private var editedDueDate = Date()

    var body: some View {
        List {
            Section(header: Text("Task details")) {
                if isEditing {
                    TextField("Enter task title", text: $editedTaskTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onAppear {
                            editedTaskTitle = task.taskTitle
                        }
                    
                    DatePicker("Due date", selection: $editedDueDate, in: Date()...)
                        .datePickerStyle(.compact)

                } else {
                    Text("Task Title: \(task.taskTitle)")
                    
                    Text("Due date: \(task.creationDate.format("dd MMM HH:mm"))")
                }
                Toggle("Mark as Completed", isOn: $task.isCompleted)
            }

          
            Section(header: Text("Estimated Time")) {
                Text("Estimated Time: \(formatTime(seconds: task.estimatedTime))")
                    .foregroundColor(.secondary)
                if isEditing {
                    Stepper(value: $editedEstimatedTimeDays, in: 0...Int.max, step: 1) {
                        Text("Days: \(editedEstimatedTimeDays)")
                            .accessibility(label: Text("Estimated Time in Days"))
                    }

                    Stepper(value: $editedEstimatedTimeMinutes, in: 0...1439, step: 1) {
                        Text("Minutes: \(editedEstimatedTimeMinutes)")
                            .accessibility(label: Text("Estimated Time in Minutes"))
                    }

                    Stepper(value: $editedEstimatedTimeSeconds, in: 0...59, step: 1) {
                        Text("Seconds: \(editedEstimatedTimeSeconds)")
                            .accessibility(label: Text("Estimated Time in Seconds"))
                    }
                }
            }

            if isEditing {
                Section(header: Text("Reward")) {
                    Stepper(value: $editedReward, in: 0...Int.max) {
                        Text("Reward: \(editedReward)")
                            .accessibility(label: Text("Reward"))
                            .fontWeight(.semibold)
                    }
                }
            }

            Section(header: Text("Actions")) {
                if isEditing {
                    Button("Cancel") {
                        isEditing = false
                    }

                    Button("Save") {
                        task.taskTitle = editedTaskTitle
                        task.estimatedTime = calculateTotalEstimatedTime()
                        task.reward = editedReward
                        task.creationDate = editedDueDate
                        isEditing = false
                    }
                } else {
                    Button("Edit") {
                        isEditing = true
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    modelContext.delete(task)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "trash")
                }
            }
        }
    }

    private func formattedDate(date: Date) -> String {
        return date.format("EEEE, MMM d, yyyy 'at' h:mm a")
    }

    func formatTime(seconds: Int) -> String {
        var seconds = seconds  // Declare seconds as a variable

        let timeUnits: [(unit: String, divisor: Int)] = [
            ("d", 86400), // days
            ("h", 3600),  // hours
            ("m", 60),    // minutes
            ("s", 1)      // seconds
        ]

        var formattedTime = ""

        for (unit, divisor) in timeUnits {
            let value = seconds / divisor

            if value > 0 {
                formattedTime += "\(value)\(unit) "
            }

            seconds %= divisor
        }

        return formattedTime.trimmingCharacters(in: .whitespaces)
    }



    private func calculateTotalEstimatedTime() -> Int {
        return editedEstimatedTimeDays * 86400 + editedEstimatedTimeMinutes * 60 + editedEstimatedTimeSeconds
    }
}


#Preview {
    TaskDetailView(task: Task(taskTitle: "Sample Task", tint: "taskColor1"))
}
