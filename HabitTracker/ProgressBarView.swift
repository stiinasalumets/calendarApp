import SwiftUI

struct ProgressBarView: View {
    private let totalHabits: Int
    private let completedHabits: Int
    private let barColor: Color

    init(totalHabits: Int, completedHabits: Int, color: String = "") {
        self.totalHabits = totalHabits
        self.completedHabits = completedHabits
        self.barColor = Color(color)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background bar
                RoundedRectangle(cornerRadius: 10)
                    .stroke(barColor.opacity(0.6), lineWidth: 2)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                    )
                    .frame(width: geometry.size.width, height: 30)

                // Filled progress bar
                if totalHabits > 0 {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(barColor)
                        .frame(
                            width: geometry.size.width * CGFloat(completedHabits) / CGFloat(totalHabits),
                            height: 30
                        )
                        .mask(RoundedRectangle(cornerRadius: 10))
                }

                // Progress text
                Text("\(completedHabits)/\(totalHabits)")
                    .foregroundColor(Color("grey"))
                    .font(.system(size: 14, weight: .bold))
            }
        }
        .frame(height: 30)
    }
}
