import SwiftUI

struct DonutChartView: View {
    var percentage: Double
    var title: String
    var color: String
    
    var body: some View {
        VStack {
            ZStack {
                // Background Circle (Empty part)
                Circle()
                    .stroke(Color("lightGrey"), lineWidth: 20)
                
                // Foreground Circle (Filled part)
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(percentage / 100, 1.0)))
                    .stroke(
                        Color(color),
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.easeOut(duration: 1.0), value: percentage)
                
                // Center Text
                Text(String(format: "%.1f", percentage))
                    .font(.system(size: 35, weight: .bold))
                    .foregroundColor(Color("grey"))
            }
            .frame(width: 100, height: 100)
            
            // Title Text below the chart
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color("grey"))
                .padding(.top, 10)
        }
    }
}
