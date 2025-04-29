import SwiftUI
import CoreData

struct ProgressBarView: View {
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(entity: DailyHabits.entity(), sortDescriptors: []) private var dailyHabits: FetchedResults<DailyHabits>

    @State private var viewModel: ViewModel
    private let totalHabits: Int
    private let completedHabits: Int
    private let barColor: Color

    init(moc: NSManagedObjectContext, totalHabits: Int, completedHabits: Int, color: String = "") {
        self._viewModel = State(wrappedValue: ViewModel(moc: moc))
        self.totalHabits = totalHabits
        self.completedHabits = completedHabits
        self.barColor = Color(color)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Full bar with border
                RoundedRectangle(cornerRadius: 10)
                    .stroke(barColor.opacity(0.6), lineWidth: 2)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                    )
                    .frame(width: geometry.size.width, height: 30)

                // Filled bar
                if totalHabits > 0 {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(barColor)
                        .frame(
                            width: (geometry.size.width) * CGFloat(completedHabits) / CGFloat(totalHabits),
                            height: 30
                        )
                        .mask(RoundedRectangle(cornerRadius: 10))
                }

                // Centered text
                Text("\(completedHabits)/\(totalHabits)")
                    .foregroundColor(Color("grey"))
                    .font(.system(size: 14, weight: .bold))
            }
        }
        .frame(height: 30)
    }
}
