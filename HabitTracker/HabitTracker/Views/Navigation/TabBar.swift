//
//  TabBar.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 25/10/22.
//

import SwiftUI

struct TabBar: View {
    @EnvironmentObject var habitVM: HabitViewModel

    @Binding var color: Color
    @Binding var selectedX: CGFloat
    @Binding var x: [CGFloat]
    
    @AppStorage("selectedTab") var selectedTab: Tab = .home
    
    var body: some View {
        GeometryReader { proxy in
            let hasHomeIndicator = proxy.safeAreaInsets.bottom > 0
            
            HStack {
                content
            }
            .padding(.bottom, hasHomeIndicator ? 16 : 0)
            .frame(maxWidth: .infinity, maxHeight: hasHomeIndicator ? 88 : 49)
            .background(.ultraThinMaterial)
            .background(
                Circle()
                    .fill(color)
                    .offset(x: selectedX, y: -10)
                    .frame(width: 88)
                    .frame(maxWidth: .infinity, alignment: .leading)
            )
            .overlay(
                Rectangle()
                    .frame(width: 28, height: 5)
                    .cornerRadius(3)
                    .frame(width: 88)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .offset(x: selectedX)
                    .blendMode(.overlay)
            )
//            .backgroundStyle(cornerRadius: hasHomeIndicator ? 25 : 0)
            .backgroundStyle(cornerRadius: 0)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
            .offset(y: habitVM.showTab ? 0 : 200)
            .accessibility(hidden: !habitVM.showTab)
        }
        .onAppear {
            self.color = tabItems.first(where: {$0.selection == selectedTab})?.color ?? Color("Purple")
        }
    }
    
    var content: some View {
        ForEach(Array(tabItems.enumerated()), id: \.offset) { index, tab in
            if index == 0 { Spacer() }
            
            Button {
                buttonVibration(intensity: 1)
                selectedTab = tab.selection
                withAnimation(.tabSelection) {
                    selectedX = x[index]
                    color = tab.color
                }
            } label: {
                VStack(spacing: 0) {
                    Image(systemName: tab.icon)
//                        .symbolVariant(.default)
                        .font(.system(size: 25, weight: .regular))
                        .frame(width: 88, height: 29)
//                    Text(tab.name).font(.caption2)
//                        .frame(width: 88)
//                        .lineLimit(1)
                }
                .overlay(
                    GeometryReader { proxy in
                        let offset = proxy.frame(in: .global).minX
                        Color.clear
                            .preference(key: TabPreferenceKey.self, value: offset)
                            .onPreferenceChange(TabPreferenceKey.self) { value in
                                x[index] = value
                                if selectedTab == tab.selection {
                                    selectedX = x[index]
                                }
                            }
                    }
                )
            }
            .frame(width: 44)
            .foregroundColor(selectedTab == tab.selection ? .primary : .secondary)
            .blendMode(selectedTab == tab.selection ? .overlay : .normal)
            
            Spacer()
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar(color: .constant(Color("Purple")), selectedX: .constant(0), x: .constant([0, 0, 0, 0, 0]))
    }
}

