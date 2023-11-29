//
//  TaskRowView.swift
//  SaveStash
//
//  Created by Quentin Gaillardet on 25/11/2023.
//

import SwiftUI

struct TaskRowView: View {
    @Bindable var task: Task
    
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Rectangle()
                .frame(maxWidth: 6, alignment: .leading)
                .foregroundColor(task.tintColor)
                .cornerRadius(4)
                .padding(.vertical, 16)
            HStack{
                VStack(alignment: .leading, spacing: 8) {
                    Text(task.taskTitle)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Label(task.creationDate.format("hh:mm a"), systemImage: "clock")
                        .font(.caption)

                }
                Spacer()
                VStack(alignment:.trailing){
                    HStack {
                        Image(systemName: "timer")
                            .symbolRenderingMode(.hierarchical)
                        
                        Text("\(formatTime(seconds: task.estimatedTime))")
                    }
                    .foregroundColor(.white)
                    .frame(height: 32)
                    .padding(.horizontal, 8)
                    
                   .background(
                       RoundedRectangle(cornerRadius: 32)
                           .fill(LinearGradient(
                            gradient: Gradient(colors: [Color.green, Color.green.opacity(0.8)]),
                               startPoint: .leading,
                               endPoint: .trailing
                           ))
                   )
                    .font(.headline)
                    .bold()
                    HStack {
                        Text("\(formatNumber(task.reward))")
                            .foregroundColor(.white)
                            .frame(height: 32)
                            .padding(.horizontal, 16)
                           .background(
                               RoundedRectangle(cornerRadius: 32)
                                   .fill(LinearGradient(
                                       gradient: Gradient(colors: [Color.yellow, Color.orange]),
                                       startPoint: .leading,
                                       endPoint: .trailing
                                   ))
                           )
                            .font(.headline)
                            .bold()
     
                            
                    }
                }
               
            } .padding(16)
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .background(Color(uiColor: .secondarySystemGroupedBackground))
                  .cornerRadius(32)
                  .shadow(color: Color(uiColor: .secondarySystemGroupedBackground).opacity(0.3), radius: 5, x: 0, y: 0)
                  .strikethrough(task.isCompleted, pattern: .solid, color: .black)
          
        }
        
    }
}

func formatTime(seconds: Int) -> String {
    let days = seconds / 86400
    let hours = (seconds % 86400) / 3600
    let minutes = (seconds % 3600) / 60
    let remainingSeconds = seconds % 60
    
    var formattedTime = ""
    
    if days > 0 {
        formattedTime += "\(days)d "
    } else if hours > 0 {
        formattedTime += "\(hours)h "
    } else if minutes > 0 {
        formattedTime += "\(minutes)m "
    } else {
        formattedTime += "\(remainingSeconds)s"
    }
    
    if hours > 0 && !formattedTime.contains("h") {
        formattedTime += "\(hours)h "
    } else if minutes > 0 && !formattedTime.contains("m") {
        formattedTime += "\(minutes)m "
    } else if remainingSeconds > 0 && !formattedTime.contains("s") {
        formattedTime += "\(remainingSeconds)s"
    }
    
    return formattedTime.trimmingCharacters(in: .whitespaces)
}

func formatNumber(_ number: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal

    switch abs(number) {
    case 0..<1_000:
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    case 1_000..<1_000_000:
        let value = Double(number) / 1_000.0
        return "\(formatter.string(from: NSNumber(value: value)) ?? "\(value)")k"
    default:
        let value = Double(number) / 1_000_000.0
        return "\(formatter.string(from: NSNumber(value: value)) ?? "\(value)")m"
    }
}



#Preview{
    TaskRowView(task: Task(taskTitle: "test", tint: "red"))
}

