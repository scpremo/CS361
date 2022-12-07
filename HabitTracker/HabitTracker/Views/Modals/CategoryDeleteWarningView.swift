//
//  CategoryDeleteWarning.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 11/15/22.
//

import SwiftUI

struct CategoryDeleteWarningView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var habitVM: HabitViewModel
    
    @Binding var selectedCategory: Category?
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.title, ascending: true)],
        animation: .default)
    private var categories: FetchedResults<Category>

    @Binding var showNewCategory: Bool
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            Color("Primary").edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 15) {
                Text("Delete \"\(selectedCategory?.title ?? "")\"?")
                    .font(.title.weight(.bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .padding(.horizontal)

                Text("Every habit with **\(selectedCategory?.title ?? "")** as its category will be modified to now have **General** as its category")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                HStack(alignment: .center, spacing: 15){
                    Button {
                        dismiss()
                    } label: {
                        Spacer()
                        Text("No, keep it")
                        Spacer()
                    }
                    .controlSize(.large)
                    .cornerRadius(15)
                    .tint(.secondary)
                    .buttonStyle(.bordered)

                    Button {
                        habitVM.deleteCategory(category: selectedCategory!)
                        selectedCategory = categories.first(where: { $0.title == "General" })
                        dismiss()
                        showNewCategory = false
                    } label: {
                        Spacer()
                        Label("Yes, Delete", systemImage: "trash")
                        Spacer()
                    }
                    .controlSize(.large)
                    .cornerRadius(15)
                    .tint(.red)
                    .buttonStyle(.borderedProminent)
                    .foregroundStyle(.red.gradient)
                }
                .padding()
            }
        }
    }
}
