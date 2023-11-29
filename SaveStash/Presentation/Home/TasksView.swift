//
//  TasksView.swift
//  SaveStash
//
//  Created by Quentin Gaillardet on 27/11/2023.
//

import SwiftUI
import SwiftData

struct TasksView: View {
    
    @Binding var currentDate : Date
    @Query private var tasks : [Task]
    
    init(currentDate: Binding<Date>) {
        self._currentDate = currentDate
        
        let calendar = Calendar.current
        let startOfDate = calendar.startOfDay(for: currentDate.wrappedValue)
        let endOfDate = calendar.date(byAdding: .day, value: 1, to: startOfDate)!
        let predicate = #Predicate<Task> {
            return $0.creationDate >= startOfDate && $0.creationDate < endOfDate
        }
        
        let sortDescriptor = [
            SortDescriptor(\Task.creationDate, order: .reverse)
        ]
        
        self._tasks = Query(filter: predicate, sort: sortDescriptor, animation: .snappy)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16){
            ForEach(tasks) { task in
                NavigationLink(destination: TaskDetailView(task: task)) {
                    TaskRowView(task: task)                    
                }
            }
        }
        .padding(.horizontal, 16)
        .overlay{
            if tasks.isEmpty {
                Text("No tasks available")
                    .font(.caption)
                    .frame(width: 200, height: 50)
            }
        }
        .padding(.top, 16)
    }
}

#Preview {
    TasksView(currentDate: .constant(Date()))
}
