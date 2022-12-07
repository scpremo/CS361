//
//  StatsView.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 11/1/22.
//

import SwiftUI
import Charts

struct StatsView: View {
    @EnvironmentObject var habitVM: HabitViewModel
    @EnvironmentObject var statsVM: StatsViewModel
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var selectedSchedule: ScheduleType = .daily
    @State var currentDate = Date()
    @State var currentMonth: Int = 0
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Habit.time, ascending: true), NSSortDescriptor(keyPath: \Habit.name, ascending: true)],
        animation: .default)
    private var habits: FetchedResults<Habit>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Entry.date, ascending: true)],
        animation: .default)
    private var entries: FetchedResults<Entry>

    @State var firstWeeksInMonth = Date().firstWeekdaysInMonth2()
    @State var selectedDate = Date()
    @State var selectedPercentage = 0.0
    @State var showAnnotation = false
    
    @State var bestStreak = 0
    @State var currentStreak = 0
    
    @State var graphValues = [CalendarValue]()
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
                    Section {
                        VStack(alignment: .center, spacing: 35) {
                            HStack(alignment: .bottom, spacing: 20) {
                                HStack(alignment: .bottom, spacing: 2) {
                                    Text("Progress for \(extraDate().month) \(String(format: "%0d", extraDate().year))")
                                        .font(.title3.bold())
                                        .offset(y: 5)
                                }
                                
                                Spacer(minLength: 0)
                                
                                Button {
                                    buttonVibration()
                                    withAnimation {
                                        currentMonth -= 1
                                    }
                                } label: {
                                    Image(systemName: "chevron.left")
                                        .font(.title2)
                                }
                                
                                Button {
                                    buttonVibration()
                                    withAnimation {
                                        currentMonth += 1
                                    }
                                    
                                } label: {
                                    Image(systemName: "chevron.right")
                                        .font(.title2)
                                }
                                
                            }
                            .padding(.horizontal)
                            .foregroundColor(.primary)

                            Chart {
                                ForEach(graphValues) { value in
                                    if value.day != -1 {
                                        if let selectedDate = selectedDate {
                                            RuleMark(x: .value("Selected date", selectedDate))
                                                .foregroundStyle(Color.primary)
                                         
                                            if let selectedPercentage {
                                                PointMark(x: .value("Selected date", selectedDate),
                                                          y: .value("Selected revenue", selectedPercentage))
                                                .foregroundStyle(Color.primary)
                                            }
                                        }
                                        
                                        BarMark(x: .value("Date", value.date, unit: .day), y: .value("Percentage", value.percentage))
                                        .interpolationMethod(.catmullRom)
                                        .symbol(.circle)
                                        .foregroundStyle(.linearGradient(colors: [Color.blue, Color.cyan], startPoint: .top, endPoint: .bottom))
                                        .annotation(position: .bottom, alignment: selectedDate > firstWeeksInMonth[1] ? .bottomTrailing : .bottomLeading) {
                                            if selectedDate == value.date && showAnnotation {
                                                VStack(alignment: .leading, spacing: 5){
                                                    Text("\(selectedDate.formatted(date: .abbreviated, time: .omitted))")
                                                        .font(.caption2)
                                                        .foregroundColor(.secondary)

                                                    Text("\(String(format: "%.0f", selectedPercentage))%")
                                                        .font(.caption2)
                                                        .foregroundColor(.primary)

                                                }
                                                .padding(5)
                                                .background(Color("Primary"))
                                                .cornerRadius(10)
                                                .zIndex(10)
                                            }
                                        }
                                    }
                                }
                            }
                            .chartXAxis {
                                AxisMarks(values: .stride(by: .day)) { value in
                                    AxisGridLine()
                                    AxisTick()
                                    if firstWeeksInMonth.contains(value.as(Date.self)!) {
                                        AxisValueLabel(format: .dateTime.day(.defaultDigits).month(.abbreviated), centered: true, orientation: .verticalReversed)
                                    }
                                    
                                }
                            }
                            .chartYAxis {
                                AxisMarks(position: .leading, values: .stride(by: 25)) { value in
                                    AxisGridLine()
                                    AxisValueLabel("\(value.index * 25)%")
                                        .font(.caption2)
                                }
                                
                            }
                            .chartYScale(domain: 0 ... 100)
                            .frame(width: getScreenSize().width - 64, height: getScreenSize().height / 3)
                            .chartOverlay(alignment: .top) { proxy in
                                GeometryReader { geometry in
                                    Rectangle().fill(.clear).contentShape(Rectangle())
                                        .gesture(DragGesture()
                                            .onChanged { value in
                                                updateSelectedDate(at: value.location,
                                                                   proxy: proxy,
                                                                   geometry: geometry)
                                            }
                                        )
                                        .onTapGesture { location in
                                            updateSelectedDate(at: location,
                                                               proxy: proxy,
                                                               geometry: geometry)
                                            buttonVibration()

                                        }
                                }
                            }
                        }
                        .padding(.vertical)
                        .background(Color("Tertiary"))
                        .cornerRadius(15)
                        .padding([.top, .horizontal])

                        HStack(alignment: .center, spacing: 20) {
                            VStack(alignment: .center, spacing: 10) {
                                Text("Current Streak")
                                    .font(.title2.weight(.medium))
                                    .foregroundStyle(.linearGradient(colors: [Color.blue, Color.cyan], startPoint: .leading, endPoint: .trailing))
                                
                                VStack(alignment: .center, spacing: 5) {
                                    RollingText(font: .title2, weight: .semibold, foregroundColor: .primary, value: $currentStreak)
                                    
                                    Text(bestStreak == 1 ? "DAY" : "DAYS")
                                        .font(.title3.weight(.semibold))
                                }
                                
                            }
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .background(Color("Tertiary"))
                            .cornerRadius(20)

                            VStack(alignment: .center, spacing: 10) {
                                Text("Best Streak")
                                    .font(.title2.weight(.medium))
                                    .foregroundStyle(.linearGradient(colors: [Color.blue, Color.cyan], startPoint: .leading, endPoint: .trailing))
                                
                                VStack(alignment: .center, spacing: 5) {
                                    RollingText(font: .title2, weight: .semibold, foregroundColor: .primary, value: $bestStreak)
                                    
                                    Text(bestStreak == 1 ? "DAY" : "DAYS")
                                        .font(.title3.weight(.semibold))
                                }
                                
                            }
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .background(Color("Tertiary"))
                            .cornerRadius(20)
                        }
                        .padding()

                    } header: {
                        HeaderView()
                    }
                }
            }
            .ignoresSafeArea(.container, edges: .top)
            .onChange(of: habitVM.currentDay) { newValue in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0)) {
                    habitVM.currentDay = newValue
                }
            }
            .onChange(of: currentMonth) { _ in
                withAnimation {
                    currentDate = getCurrentMonth()
                    firstWeeksInMonth = currentDate.firstWeekdaysInMonth2()
                    selectedDate = currentDate
                    graphValues = extractDate()
                }
            }
            .onTapGesture {
                showAnnotation = false
            }
            .onAppear {
                bestStreak = statsVM.getBestStreak()
                currentStreak = statsVM.getCurrentStreak()
//                if graphValues.isEmpty {
                    graphValues = extractDate()
//                }
            }
//            .onChange(of: habitVM.entries.count) { newValue in
//                if habitVM.entries.count != newValue {
//                    graphValues = extractDate()
//                }
//            }
        }
        .background(Color("Primary").ignoresSafeArea())
    }
    
    private func updateSelectedDate(at location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) {
        showAnnotation = true
        let data = extractDate()

        let xPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        guard let date: Date = proxy.value(atX: xPosition) else {
            return
        }
        if date >= data.last!.date {
            return
        }

        selectedDate = data
            .sorted(by: {
                abs($0.date.timeIntervalSince(date)) < abs($1.date.timeIntervalSince(date))
            })
            .first!.date

        selectedPercentage = statsVM.getDayHabitsPercentage(habits: habits.map({ habit in
            return habit
        }), selectedDate: selectedDate)
//        print(selectedDate)
    }
    
    func HeaderView() -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Stats")
                    .font(.largeTitle.bold())
            }
            .hLeading()
        }
        .padding()
        .padding(.top, getSafeArea().top)
        .background(Color("Primary"))
        
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func extraDate() -> (year: Int, month: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        let components = Calendar.current.dateComponents([.year], from: currentDate)
        let date = formatter.string(from: currentDate)
        
        return (year: components.year!, month: date)
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        
        return currentMonth
    }
    
    func extractDate() -> [CalendarValue] {
        let calendar = Calendar.current
        
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap { date -> CalendarValue in
            let day = calendar.component(.day, from: date)
            let percentage = habitVM.getDayHabitsPercentage(habits: habits.map({ habit in
                return habit
            }), selectedDate: date)
            return CalendarValue(day: day, date: date, percentage: percentage * 100)
        }
        
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1 {
            days.insert(CalendarValue(day: -1, date: Date(), percentage: 0), at: 0)
        }
        
        return days
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
            .environmentObject(HabitViewModel())
            .environmentObject(StatsViewModel())
    }
}

extension Date {
    func month(using calendar: Calendar = .current) -> Int {
        calendar.component(.month, from: self)
    }
    
    func firstWeekdaysInMonth2(using calendar: Calendar = .current) -> [Date] {
        var components = calendar.dateComponents([.calendar, .yearForWeekOfYear], from: self)
        return calendar.range(of: .weekOfYear, in: .month, for: self)?.compactMap {
            components.weekOfYear = $0
            return components.date?.noon.month(using: calendar) == month(using: calendar) ? components.date : nil
        } ?? []
    }
}
