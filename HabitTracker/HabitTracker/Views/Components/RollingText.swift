//
//  RollingText.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 11/8/22.
//

import SwiftUI


struct RollingText: View {
    var font: Font = .body
    var weight: Font.Weight = .medium
    var foregroundColor: Color = .primary
    @Binding var value: Int
    
    @State private var animationRange: [Int] = []
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(0..<animationRange.count, id: \.self) { index in
                Text("8")
                    .font(font)
                    .fontWeight(weight)
                    .opacity(0)
                    .overlay {
                        GeometryReader { proxy in
                            let size = proxy.size
                            
                            VStack(spacing: 0) {
                                ForEach(0...9, id: \.self) { number in
                                    Text("\(number)")
                                        .font(font)
                                        .fontWeight(weight)
                                        .foregroundColor(foregroundColor)
                                        .frame(width: size.width, height: size.height, alignment: .center)
                                    
                                }
                            }
                            .offset(y: -CGFloat(animationRange[index]) * size.height)
                        }
                            .clipped()
                    }
            }
        }
        .onAppear {
            animationRange = Array(repeating: 0, count: "\(value)".count + 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
                updateText()
            }
        }
        .onChange(of: value) { newValue in
            let extra = "\(newValue)".count - animationRange.count

            if extra > 0 {
                for _ in 0..<extra {
                    withAnimation(.easeIn(duration: 0.1)) {
                        animationRange.append(0)
                    }
                }
            } else {
                for _ in 0..<(-extra) {
                    animationRange.removeLast()
                }

            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                updateText()
            }
        }
    }
    
    func updateText() {
        let stringValue = "\(value)"
        
        if animationRange.count - stringValue.count == 1 {
            animationRange.removeLast()
        }
        
        for (index, value) in zip(0..<stringValue.count, stringValue) {
            var fraction = Double(index) * 0.15
            fraction = (fraction < 0.5 ? 0.5 : fraction)

            withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 1 + fraction, blendDuration: 1 + fraction)) {
                if index < stringValue.count {
                    animationRange[index] = (String(value) as NSString).integerValue
                }
                
            }
        }
    }
}

struct RollingText_Previews: PreviewProvider {
    static var previews: some View {
        RollingText(value: .constant(0))
    }
}
