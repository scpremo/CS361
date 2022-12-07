//
//  NewCategoryView.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 10/31/22.
//

import SwiftUI

struct NewCategoryView: View {
    @Binding var categoryText: String
    @Binding var selectedColor: String
    @Binding var isNew: Bool
    let columns = Array(repeating: GridItem(.flexible()), count: 5)
    let colors: [Color] = [Color("Red"), Color("Pink"), Color("Orange"), Color("Yellow"), Color("Green"), Color("Mint"), Color("Cyan"), Color("Blue"), Color("Indigo"), Color("Purple")]
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var habitVM: HabitViewModel
    @Binding var selectedCategory: Category?
    
    @State var showDeleteWarning = false
    @Binding var showNewCategory: Bool
    
    var body: some View {
        ZStack {
            Color("Primary")
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center, spacing: 10) {
                    Text(isNew ? "New Category" : "Edit Category")
                        .font(.title.bold())
                    
                    Spacer()
                    
                    Button {
                        buttonVibration()
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundColor(Color("InvertedText"))
                            .padding(8)
                            .background(Color("ButtonPrimary"))
                            .cornerRadius(10)

                    }

                }
                .padding(.horizontal)
                
                CustomField(searchText: $categoryText, image: "", text: "e.g. Athletics", backgroundColor: Color("Tertiary"))
                    .padding()
                    .opacity(!isNew && categorySamples.contains(where: { $0.title == selectedCategory?.title }) ? 0.5 : 1)
                    .disabled(!isNew && categorySamples.contains(where: { $0.title == selectedCategory?.title }) ? true : false)
                
                if !isNew && categorySamples.contains(where: { $0.title == selectedCategory?.title }) {
                    Text("The title for default categories cannot be modified")
                        .foregroundColor(.secondary)
                        .font(.caption2)
                        .padding(.horizontal)
                        .padding(.top, -10)
                }
             
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(colors, id: \.self) { color in
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0)) {
                                selectedColor = color.description
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .frame(width: 40, height: 40, alignment: .center)
                                .foregroundColor(color)
                                .padding(10)
                                .background(selectedColor == color.description ? Color("ButtonPrimary") : Color("Primary"))
                                .cornerRadius(15)
                                .padding()
                        }
                    }
                }
                .padding(.horizontal)
                
                HStack(alignment: .center, spacing: 10) {
                    if !isNew && !categorySamples.contains(where: { $0.title == selectedCategory?.title }) {
                        Button {
                            showDeleteWarning.toggle()
                        } label: {
                            Spacer()
                            Label("Delete", systemImage: "trash")
                            Spacer()
                        }
                        .controlSize(.large)
                        .cornerRadius(15)
                        .tint(.red)
                        .buttonStyle(.bordered)
                    }
                    
                    Button {
                        if isNew {
                            selectedCategory = habitVM.addCategory(title: categoryText, color: selectedColor.description.components(separatedBy: "\"")[1])
                        } else {
                            selectedCategory?.title = categoryText
                            selectedCategory?.color = selectedColor.description.components(separatedBy: "\"")[1]
                            habitVM.refreshID = UUID()
                        }
                        do {
                            try viewContext.save()
                            successVibration()
                        } catch {
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                        dismiss()
                    } label: {
                        HStack {
                            Spacer()
                            Label("Save", systemImage: "plus.circle")
                                .font(.title3.weight(.bold))
                            Spacer()
                        }
                        .padding(14)
                        .background(categoryText == "" ? Color("ButtonPrimary").opacity(0.2) : Color("ButtonPrimary"))
                        .foregroundColor(categoryText == "" ? .primary : Color("InvertedText"))
                        .cornerRadius(15)
                    }
                    .disabled(categoryText == "" ? true : false)
                    
                   
                }
                .padding(.horizontal)
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onDisappear {
            categoryText = ""
            selectedColor = Color("Red").description
        }
        .sheet(isPresented: $showDeleteWarning) {
            CategoryDeleteWarningView(selectedCategory: $selectedCategory, showNewCategory: $showNewCategory)
                .presentationDetents([.fraction(0.25)])
        }
//        .background(Color("Primary").edgesIgnoringSafeArea([.top, .bottom]))
    }
}
