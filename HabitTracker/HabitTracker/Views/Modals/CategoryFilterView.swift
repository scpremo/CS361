//
//  CategoryFilterView.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 11/8/22.
//

import SwiftUI

struct CategoryFilterView: View {
    @Environment(\.dismiss) var dismiss
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.title, ascending: true)],
        animation: .default)
    private var categories: FetchedResults<Category>
    @Binding var selectedCategory: Category?
    
    var body: some View {
        ZStack {
            Color("Primary")
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center, spacing: 10) {
                    Text("Filter by Category")
                        .font(.title.bold())
                    
                    Spacer()
                    
                    Button {
                        buttonVibration()
                        dismiss()
                    } label: {
                        Text("Done")
                            .foregroundColor(Color("InvertedText"))
                            .padding(8)
                            .background(Color("ButtonPrimary"))
                            .cornerRadius(10)

                    }

                }
                .padding(.horizontal)

                WrappedLayout(categories: categories.map({ category in
                    return category
                }), selectedCategory: $selectedCategory, showAllFilter: true, notSelectedColor: Color("Tertiary"))
                .padding(.horizontal, 10)
//                
//                Button {
//                    
//                } label: {
//                    Spacer()
//                    Label("Edit", systemImage: "pencil")
//                    Spacer()
//                }
//                .tint(.primary)
//                .cornerRadius(15)
//                .buttonStyle(.bordered)
//                .controlSize(.large)
//                .padding()
                
                Spacer()
            }
            .padding(.top)
        }
    }
}
