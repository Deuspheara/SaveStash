//
//  HomeView.swift
//  SaveStash
//
//  Created by Quentin Gaillardet on 04/11/2023.
//


import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var currentDate: Date = .init()
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 0
    @State private var createWeek: Bool = false
    @State private var createNewTask: Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    @Namespace private var animation
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ScrollView(.vertical) {
                    VStack {
                        TasksView(currentDate: $currentDate)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .padding(.top, 200)
                }
                .scrollIndicators(.hidden)
                
                HeaderView()
            }
            .overlay(alignment: .bottomTrailing) {
                addButton
            }
            .onAppear(perform: onAppearHandler)
            .sheet(isPresented: $createNewTask) {
                AddTaskView()
                    .presentationDetents([.medium])
                    .interactiveDismissDisabled()
                    .presentationCornerRadius(30)
                    .presentationBackground(.background)
                
            }
            #if os(iOS)
            .background(Color(uiColor: .systemGroupedBackground))
            #else
            .background(.quaternary.opacity(0.5))
            #endif
            .background()
        }
    }
    
    private var addButton: some View {
        Button(action: { createNewTask = true }) {
            Image(systemName: "plus")
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 55, height: 55)
                .background(
                    Color.blue
                        .shadow(.drop(color: .black.opacity(0.25), radius: 5, x: 10, y: 10)),
                    in: .circle
                )
        }
        .padding(.trailing, 24)
    }
    
    private func onAppearHandler() {
        if weekSlider.isEmpty {
            setupWeekSlider()
        }
    }
    
    private func setupWeekSlider() {
        let currentWeek = Date().fetchWeek()
        if let firstDate = currentWeek.first?.date {
            weekSlider.append(firstDate.createPreviousWeek())
        }
        weekSlider.append(currentWeek)
        
        if let lastDate = currentWeek.last?.date {
            weekSlider.append(lastDate.createNextWeek())
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        
        Rectangle()
            .foregroundColor(Color(uiColor: .secondarySystemGroupedBackground).opacity(0.8))
            .background(.ultraThinMaterial)
            .clipShape(.rect(bottomLeadingRadius: 32, bottomTrailingRadius: 32))
            .ignoresSafeArea()
            .frame(height: 200, alignment: .top)
            .overlay(
                VStack(){
                    HStack {
                        Image("profilePicture")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .padding(.leading, 16)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Image("coins")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text("5")
                                    .foregroundColor(.orange)
                                    .font(.headline)
                                    .bold()
                                
                            }
                            .font(.subheadline)
                            Text("Arthur")
                                .font(.title2)
                                .bold()
                        }
                        Spacer()
                    }
                    TabView(selection : $currentWeekIndex){
                        ForEach(weekSlider.indices, id: \.self){ index in
                            let week = weekSlider[index]
                            WeekView(week)
                                .tag(index)
                            
                        }
                    }
                    .padding(.horizontal, -8)
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    
                }
            )
            .onChange(of: currentWeekIndex, initial: false) { oldValue, newValue in
                if newValue == 0 || newValue == (weekSlider.count - 1){
                    createWeek = true
                }
            }
    }
    
    
    @ViewBuilder
    func WeekView(_ week: [Date.WeekDay]) -> some View {
        HStack(spacing:8) {
            ForEach(week){ day in
                
                VStack(spacing : 8) {
                    Text(day.date.format("E"))
                        .font(.caption)
                        .textCase(.uppercase)
                        .foregroundColor(isSameDate(day.date, currentDate) ? .white : .gray)
                    Divider().frame(width: 20)
                    Text(day.date.format("dd"))
                        .font(.title2)
                        .bold()
                        .foregroundColor(isSameDate(day.date, currentDate) ? .white : Color(.label))
                    
                }
                .frame(width: 45, height: 80)
                .background(content: {
                    if isSameDate(day.date, currentDate) {
                        Rectangle()
                            .fill(.blue)
                            .cornerRadius(20)
                            .matchedGeometryEffect(id: "TABINDICATOR", in: animation)
                        
                        
                    }else{
                        Rectangle()
                            .fill(Color(UIColor.systemGroupedBackground))
                            .cornerRadius(20)
                    }
                    
                    if day.date.isToday{
                        Circle()
                            .fill(.blue)
                            .frame(width: 10, height: 10)
                            .offset(y: 50)
                    }
                })
                
                .onTapGesture {
                    withAnimation(.snappy){
                        currentDate = day.date
                    }
                }
            }
        }
        .overlay{
            GeometryReader {
                let minX = $0.frame(in: .global).minX
                
                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self, perform: { value in
                        if value.rounded() == 15 && createWeek {
                            paginateWeek()
                            print("Generate")
                            createWeek = false
                        }
                    }
                    )
            }
        }
    }
    
    
    func paginateWeek(){
        if weekSlider.indices.contains(currentWeekIndex){
            if let firstDate = weekSlider[currentWeekIndex].first?.date, currentWeekIndex == 0 {
                weekSlider.insert(firstDate.createPreviousWeek(), at: 0)
                weekSlider.removeLast()
                currentWeekIndex = 1
            }
            if let lastDate = weekSlider[currentWeekIndex].last?.date, currentWeekIndex == (weekSlider.count - 1) {
                weekSlider.append(lastDate.createNextWeek())
                weekSlider.removeFirst()
                currentWeekIndex = weekSlider.count - 2
            }
        }
    }
    
}

#Preview {
    HomeView()
}
