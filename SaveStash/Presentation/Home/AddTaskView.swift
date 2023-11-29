//
//  AddTaskView.swift
//  SaveStash
//
//  Created by Quentin Gaillardet on 26/11/2023.
//

import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var context
    
    @State private var taskTitle: String = ""
    @State private var taskDate: Date = .init()
    @State private var taskColor : String = "taskColor4"
    @State private var estimatedTimeDays: Int = 0
    @State private var estimatedTimeMinutes: Int = 0
    @State private var estimatedTimeSeconds: Int = 0
    @State private var reward: Int = 0
    
    var totalEstimatedTimeSeconds: Int {
        return estimatedTimeDays * 86400 + estimatedTimeMinutes * 60 + estimatedTimeSeconds
    }
    
    
    var colors: [String] = ["taskColor1", "taskColor2", "taskColor3", "taskColor4"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            ScrollView{
                LazyVStack(alignment: .leading, spacing: 8) {
                    Text("Task Title")
                        .font(.title2)
                        .fontWeight(.semibold)
                    TextField("Go for a Walk!", text: $taskTitle)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray, lineWidth: 1))
                        .accessibility(label: Text("Task Title"))
                }
                .padding(.top, 80)
                
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Task Date")
                            .font(.title2)
                            .fontWeight(.semibold)
                        DatePicker("", selection: $taskDate)
                            .datePickerStyle(.compact)
                            .scaleEffect(0.9, anchor: .leading)
                            .accessibility(label: Text("Task Date"))
                    }
                    .padding(.trailing, 30)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Task Color")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.primary)
                        
                        HStack(spacing: 8) {
                            ForEach(colors, id: \.self) { color in
                                Circle()
                                    .fill(Color(color))
                                    .frame(width: 20, height: 20)
                                    .overlay(
                                        Circle()
                                            .stroke(lineWidth: 2)
                                            .opacity(taskColor == color ? 1 : 0)
                                    )
                                    .onTapGesture {
                                        withAnimation(.snappy) {
                                            taskColor = color
                                        }
                                    }
                            }
                        }
                    }
                    .padding(.trailing, 8)
                }
                .padding(.top, 5)
                
                
                Text("Estimated Time")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                VStack(spacing: 8) {
                    Stepper(value: $estimatedTimeDays, in: 0...Int.max, step: 1) {
                        Text("Days: \(estimatedTimeDays)")
                            .accessibility(label: Text("Estimated Time in Days"))
                            .fontWeight(.semibold)
                    }
                    
                    Stepper(value: $estimatedTimeMinutes, in: 0...1439, step: 1) {
                        Text("Minutes: \(estimatedTimeMinutes)")
                            .accessibility(label: Text("Estimated Time in Minutes"))
                            .fontWeight(.semibold)
                    }
                    
                    Stepper(value: $estimatedTimeSeconds, in: 0...59, step: 1) {
                        Text("Seconds: \(estimatedTimeSeconds)")
                            .accessibility(label: Text("Estimated Time in Seconds"))
                            .fontWeight(.semibold)
                    }
                }
                
                
                Text("Reward")
                    .font(.title2)
                    .fontWeight(.semibold)
                Stepper(value: $reward, in: 0...Int.max) {
                    Text("Reward: \(reward)")
                        .accessibility(label: Text("Reward"))
                        .fontWeight(.semibold)
                }
                
                
                Spacer()
                
                Button(action: {
                    let task = Task(taskTitle: taskTitle, creationDate: taskDate, tint: taskColor, reward: reward, estimatedTime: totalEstimatedTimeSeconds)
                    do {
                        context.insert(task)
                        try context.save()
                        dismiss()
                    } catch {
                        print("Error creating task: \(error.localizedDescription)")
                    }
                }) {
                    Text("Create Task")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .textScale(.secondary)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(taskColor))
                        .cornerRadius(10)
                        .shadow(radius: 2)
                }
                .disabled(taskTitle.isEmpty || totalEstimatedTimeSeconds <= 0 || reward <= 0)
                .opacity((taskTitle.isEmpty || totalEstimatedTimeSeconds <= 0 || reward <= 0) ? 0.5 : 1)
            }
            .padding(.horizontal, 24)
            .overlay(alignment: .top) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .font(.title)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: 60, alignment: .trailing)
                .padding(.horizontal, 24)
                .background(.thinMaterial)
            }
            .scrollIndicators(.hidden)
        }
    }
}


#Preview {
    AddTaskView()
}
