import Foundation
import SwiftUI
import CoreData

class ProgressBarViewModel: ObservableObject {
    @Published var totalHabits: Int = 0
    @Published var completedHabits: Int = 0

    var progressFraction: CGFloat {
        totalHabits > 0 ? CGFloat(completedHabits) / CGFloat(totalHabits) : 0
    }

    var progressText: String {
        "\(completedHabits)/\(totalHabits)"
    }

    func computeProgress(from habits: [DailyHabits]) {
        totalHabits = habits.count
        completedHabits = habits.filter { $0.isCompleted }.count
    }
}
