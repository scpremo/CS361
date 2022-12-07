//
//  TagView2.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 10/29/22.
//

import SwiftUI

struct WrappedLayout: View {
    var categories: [Category]

    @State private var totalHeight
          = CGFloat.zero       // << variant for ScrollView/List
//            = CGFloat.infinity   // << variant for VStack

    @Binding var selectedCategory: Category?
    @EnvironmentObject var habitVM: HabitViewModel
    var showAllFilter: Bool = false
    var notSelectedColor: Color = Color("Primary")
    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        .frame(height: totalHeight)// << variant for ScrollView/List
        //.frame(maxHeight: totalHeight) // << variant for VStack
    }

    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(self.categories, id: \.self) { category in
                if category == categories.first && showAllFilter {
                    Button {
                        buttonVibration()
                        withAnimation {
                            selectedCategory = nil
                        }
                    } label: {
                        HStack(alignment: .center, spacing: 10) {
                            Text("All")
                                .foregroundColor(selectedCategory == nil ? Color("InvertedText") : .primary)
                            
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .frame(width: 20, height: 20, alignment: .center)
                                .foregroundColor(selectedCategory == nil ? Color("InvertedText") : .primary)
                                .id(habitVM.refreshID)
                        }
                        .padding(10)
                        .background(selectedCategory == nil ? Color("ButtonPrimary") : notSelectedColor)
                        .background(Color("Primary"))
                        .cornerRadius(12)
                        .padding(.vertical, 5)
                    }
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if category == self.categories.last! {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if category == self.categories.last! {
                            height = 0 // last item
                        }
                        return result
                    })
                }
                
                self.item(for: category)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if category == self.categories.last! {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { d in
                        let result = height
                        if category == self.categories.last! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }.background(viewHeightReader($totalHeight))
    }

    private func item(for category: Category) -> some View {
        Button {
            buttonVibration()
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0)) {
                selectedCategory = category
            }
        } label: {
            HStack(alignment: .center, spacing: 10) {
                Text(category.title ?? "No title")
                    .foregroundColor(selectedCategory == category ? Color("InvertedText") : .primary)
                
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .frame(width: 20, height: 20, alignment: .center)
                    .foregroundColor(Color(category.color ?? ""))
                    .id(habitVM.refreshID)
            }
            .padding(10)
            .background(selectedCategory == category ? Color("ButtonPrimary") : notSelectedColor)
            .background(Color("Primary"))
            .cornerRadius(12)
            .padding(.vertical, 5)
        }
    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}

