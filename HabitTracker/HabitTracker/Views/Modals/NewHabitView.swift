//
//  NewHabitView.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 18/10/22.
//

import SwiftUI
import WrappingHStack

struct NewHabitView: View {
    @EnvironmentObject var habitVM: HabitViewModel
    @Environment(\.dismiss) private var dismiss
    
    @Binding var name: String
    @Binding var selectedCategory: Category?
    @Binding var schedule: ScheduleType
    
    @Binding var timesPerWeek: Int
    @Binding var hasDays: Bool
    
    @Binding var days: [Int]
    @Binding var time: Date
    @Binding var hasTime: Bool
        
    @State var showNewCategory = false
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.title, ascending: true)],
        animation: .default)
    private var categories: FetchedResults<Category>
    
    @State var categoryText = ""
    @State var categorySelectedColor = Color("Red").description
    @State var isCategoryNew = true
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Name")
                                .font(.headline)
                            
                            CustomField(searchText: $name, text: "e.g. Read every day")
                        }
                        .padding(10)
                        .background(Color("Tertiary"))
                        .cornerRadius(20)
                        .padding()
                        
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Category")
                                    .font(.headline)
                                
                                Spacer()
                                
                                Button {
                                    categoryText = selectedCategory?.title ?? ""
                                    categorySelectedColor = Color(selectedCategory?.color ?? "Red").description
                                    isCategoryNew = false
                                    showNewCategory = true
                                    buttonVibration()
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                        .foregroundColor(.primary)
                                }

                            }
                            
                            //                                Spacer()
                            
                            WrappedLayout(categories: categories.map({ category in
                                return category
                            }), selectedCategory: $selectedCategory)
                            
                            Button {
                                buttonVibration()
                                isCategoryNew = true
                                showNewCategory.toggle()
                            } label: {
                                HStack {
                                    Spacer()
                                    Label("Add Category", systemImage: "plus.circle")
                                    Spacer()
                                }
                                .font(.body.weight(.bold))
                                .padding()
                                .foregroundColor(Color.primary)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .strokeBorder(
                                            style: StrokeStyle(
                                                lineWidth: 2,
                                                dash: [15]
                                            )
                                        )
                                        .foregroundColor(.primary)
                                )
                            }
                            .sheet(isPresented: $showNewCategory) {
                                NewCategoryView(categoryText: $categoryText, selectedColor: $categorySelectedColor, isNew: $isCategoryNew, selectedCategory: $selectedCategory, showNewCategory: $showNewCategory)
                                    .presentationDetents([.fraction(0.55)])
                            }
                        }
                        
                        .padding(10)
                        .background(Color("Tertiary"))
                        .cornerRadius(20)
                        .padding()
                        
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Schedule")
                                .font(.headline)

                            SchedulePickerItem(selectedSchedule: $schedule, padding: 8, backgroundColor: Color("Primary"))
                                .cornerRadius(0)
                            
                        }
                        .padding(10)
                        .background(Color("Tertiary"))
                        .cornerRadius(20)
                        .padding()
                        
                        if schedule.rawValue == "Weekly" {
                            HStack(alignment: .center, spacing: 10) {
                                Text("Times per week")
                                    .font(.headline)
                                
                                
                                Spacer()
                                HStack(alignment: .center, spacing: 10) {
                                    Button {
                                        buttonVibration()
                                        decrementStep()
                                    } label: {
                                        Image(systemName: "minus")
                                            .padding(5)
                                            .frame(width: 30, height: 30, alignment: .center)
                                            .background(Color("Primary"))
                                            .cornerRadius(10)
                                            .foregroundColor(.primary)
                                    }
                                    
                                    Text("\(timesPerWeek)")
                                        .font(.subheadline)
                                        .foregroundColor(.primary)
                                        .fixedSize(horizontal: true, vertical: false)
                                        .monospacedDigit()
                                        .id(habitVM.refreshID)
                                    
                                    Button {
                                        buttonVibration()
                                        incrementStep()
                                    } label: {
                                        Image(systemName: "plus")
                                            .padding(5)
                                            .frame(width: 30, height: 30, alignment: .center)
                                            .background(Color("Primary"))
                                            .cornerRadius(10)
                                            .foregroundColor(.primary)
                                    }
                                    
                                }
                            }
                            .padding(10)
                            .background(Color("Tertiary"))
                            .cornerRadius(20)
                            .padding()
                            
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(alignment: .center) {
                                    Text("Days")
                                        .font(.headline)
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: withAnimation { $hasDays })
                                        .labelsHidden()
                                }
                                
                                if hasDays {
                                    
                                    HStack(alignment: .center, spacing: 10) {
                                        ForEach(1...7, id:\.self) { day in
                                            Button {
                                                buttonVibration()
                                                if !days.contains(day) && days.count < timesPerWeek {
                                                    days.append(day)
                                                } else {
                                                    if let index = days.firstIndex(of: day) {
                                                        days.remove(at: index)
                                                    }
                                                }
                                            } label: {
                                                
                                                HStack {
                                                    Spacer()
                                                    Text(day.numberToSingleLetterDay())
                                                    Spacer()
                                                }
                                                .padding(.horizontal, 6)
                                                .padding(.vertical, 10)
                                                .background(days.contains(day) ? Color("ButtonPrimary") : Color("Primary"))
                                                .foregroundColor(days.contains(day) ? Color("InvertedText") : .primary)
                                                .cornerRadius(12)
                                                .padding(.vertical, 5)
                                                
                                            }
                                            
                                            
                                        }
                                    }
                                }
                            }
                            .padding(10)
                            .background(Color("Tertiary"))
                            .cornerRadius(20)
                            .padding()
                            .animation(.easeInOut, value: schedule)
                            .transition(.opacity)
                        }
                        
                        
                        
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(alignment: .center, spacing: 25) {
                                Text("Time")
                                    .font(.headline)
                                
                                Spacer()
                                
                                
                                DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                    .disabled(!hasTime)
                                    .opacity(hasTime ? 1 : 0.5)
                                    .datePickerStyle(.compact)
                                
                                Toggle("Time", isOn: $hasTime)
                                    .labelsHidden()
                                
                            }
                            
                            
                            
                        }
                        .padding(10)
                        .background(Color("Tertiary"))
                        .cornerRadius(20)
                        .padding()
                        
                        Spacer()
                        
                    }
                    
                }
                
                Button {
                    habitVM.addHabit(name: name, category: selectedCategory!, time: time, hasTime: hasTime, schedule: schedule.rawValue, days: days, hasDays: hasDays, timesPerWeek: timesPerWeek)
                    successVibration()
                    dismiss()
                } label: {
                    Spacer()
                    Label("Add Habit", systemImage: "plus.circle")
                        .font(.title3.weight(.bold))
                        .foregroundColor(name != "" && schedule.rawValue == "Weekly" && hasDays && days.count == timesPerWeek ? Color("InvertedText") : (name != "" && schedule.rawValue == "Weekly" && !hasDays ? Color("InvertedText") : (name != "" && schedule.rawValue == "Daily" ? Color("InvertedText") : .primary)))
                    
                    Spacer()
                }
                .tint(.blue)
                .padding(10)
                .padding(.vertical, 7)
                .background(
                    ZStack {
                        if name != "" && schedule.rawValue == "Daily" {
                            Color("ButtonPrimary")
                        } else if name != "" && schedule.rawValue == "Weekly" && !hasDays {
                            Color("ButtonPrimary")
                        } else if name != "" && schedule.rawValue == "Weekly" && hasDays && days.count == timesPerWeek {
                            Color("ButtonPrimary")
                        } else {
                            Color("ButtonPrimary").opacity(0.2)
                        }
                    }
                )
                .cornerRadius(15)
                .padding()
                .disabled(name == "" ? true : false)
                .disabled(schedule.rawValue == "Weekly" && hasDays && days.count != timesPerWeek ? true : false)
                .transition(.opacity)
            }
            .background(Color("Primary"))
            .navigationTitle("New Habit")
            //            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    buttonVibration()
                    Task { @MainActor in
                        habitVM.showNewHabit = false
                    }

                } label: {
                    Text("Cancel")
                        .foregroundColor(Color("InvertedText"))
                        .padding(8)
                        .background(Color("ButtonPrimary"))
                        .cornerRadius(10)
                }
            }
            .ignoresSafeArea(.keyboard)
            .onTapGesture {
                hideKeyboard()
            }
            
        }
        .onAppear {
            selectedCategory = categories.first
        }
        .onDisappear {
            name = ""
            selectedCategory = categories.first
            schedule = .daily
            timesPerWeek = 1
            hasDays = false
            days = [Int]()
            time = Date()
            hasTime = false
        }
    }
    
    func incrementStep() {
        timesPerWeek += 1
        if timesPerWeek >= 7 { timesPerWeek = 7 }
    }
    
    func decrementStep() {
        timesPerWeek -= 1
        if timesPerWeek <= 0 { timesPerWeek = 1 }
        if days.count > 1 {
            withAnimation { days.removeLast() }
        }
    }
}

//struct NewHabitView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewHabitView()
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}

