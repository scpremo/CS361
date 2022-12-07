//
//  ActivityRingView.swift
//  HabitTracker
//
//  Created by Arturo Diaz on 27/10/22.
//

import SwiftUI

struct ProgressRingItem: View {
    @Binding var show: Bool
    var progress: Double
    var ringRadius: Double = 60.0
    var thickness: CGFloat = 20.0
    var startColor = Color(red: 0.784, green: 0.659, blue: 0.941)
    var endColor = Color(red: 0.278, green: 0.129, blue: 0.620)
    var showText: Bool = false
    
    private var ringTipShadowOffset: CGPoint {
        let ringTipPosition = tipPosition(progress: show ? progress : 0, radius: ringRadius)
        let shadowPosition = tipPosition(progress: show ? progress + 0.0075 : 0, radius: ringRadius)
        return CGPoint(x: shadowPosition.x - ringTipPosition.x,
                       y: shadowPosition.y - ringTipPosition.y)
    }
    
    private func tipPosition(progress:Double, radius:Double) -> CGPoint {
        let progressAngle = Angle(degrees: (360.0 * progress) - 90.0)
        return CGPoint(
            x: radius * cos(progressAngle.radians),
            y: radius * sin(progressAngle.radians))
    }
    
    var body: some View {
        let gradient = LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .topLeading, endPoint: .topTrailing)
        
        ZStack {
            if showText {
                Circle()
                    .stroke(Color.white.opacity(0.15), lineWidth: thickness)
                    .frame(width: CGFloat(ringRadius) * 2.0, height: CGFloat(ringRadius) * 2.0)
            }
            
            Circle()
                .trim(from: 0, to: CGFloat(show ? self.progress : 0))
                .stroke(
                    gradient,
                    style: StrokeStyle(lineWidth: thickness, lineCap: .round, dash: [50, 0]))
                .rotationEffect(Angle(degrees: -90))
                .frame(width: CGFloat(ringRadius) * 2.0, height: CGFloat(ringRadius) * 2.0)
            ActivityRingTip(show: $show, progress: show ? progress : 0,
                            ringRadius: Double(ringRadius))
                .fill(progress > 0.95 ? endColor : .clear)
                .frame(width: thickness, height: thickness)
                .shadow(color: progress > 0.95 ? .black.opacity(0.3) : .clear,
                        radius: 2.5,
                        x: ringTipShadowOffset.x,
                        y: ringTipShadowOffset.y)
            
            if showText {
                Text("\(String(format: "%0.0f", progress*100))%")
                    .font(.system(size: 2.2 * thickness))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    .foregroundColor(.white)
            }
        }
    }
    
}

struct ActivityRingView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressRingItem(show: .constant(true), progress: 0.9)
            .environmentObject(HabitViewModel())
    }
}



struct ActivityRingTip: Shape {
    @Binding var show: Bool
    var progress: Double
    var ringRadius: Double
    
    private var position: CGPoint {
        let progressAngle = Angle(degrees: (360.0 * (show ? progress : 1)) - 90.0)
        return CGPoint(
            x: ringRadius * cos(progressAngle.radians),
            y: ringRadius * sin(progressAngle.radians))
    }
    
    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        if progress > 0.0 {
            path.addEllipse(in: CGRect(
                                x: position.x,
                                y: position.y,
                                width: rect.size.width,
                                height: rect.size.height))
        }
        return path
    }
}
