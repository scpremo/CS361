//
//  EditHabitView.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 11/15/22.
//

import SwiftUI

struct EditHabitView: View {
    @EnvironmentObject var habitVM: HabitViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State var name = ""
    @Binding var selectedHabit: Habit?
    @State var selectedCategory: Category?
    
    @State var time = Date()
    @State var hasTime = false
            
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
                    habitVM.updateHabit(habit: selectedHabit!, name: name, category: selectedCategory!, time: time, hasTime: hasTime)
                    successVibration()
                    dismiss()
                } label: {
                    Spacer()
                    Text("Save Habit")
                        .font(.title3.weight(.bold))
                        .foregroundColor(selectedHabit?.name != "" ? Color("InvertedText") : .primary)
                    
                    Spacer()
                }
                .tint(.blue)
                .padding(10)
                .padding(.vertical, 7)
                .background(
                    ZStack {
                        if selectedHabit?.name != "" {
                            Color("ButtonPrimary")
                        } else {
                            Color("ButtonPrimary").opacity(0.2)
                        }
                    }
                )
                .cornerRadius(15)
                .padding()
                .disabled(selectedHabit?.name == "" ? true : false)
                .transition(.opacity)
            }
            .background(Color("Primary"))
            .navigationTitle("Edit Habit")
            .toolbar {
                Button {
                    buttonVibration()
                    Task { @MainActor in
                        habitVM.showEditHabit = false
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
            name = selectedHabit?.name ?? ""
            hasTime = selectedHabit?.time != nil ? true : false
            time = selectedHabit?.time ?? Date()
            selectedCategory = selectedHabit?.category ?? categories.first
        }
        
        .onDisappear {
            selectedCategory = categories.first
            hasTime = false
        }
    }
}
