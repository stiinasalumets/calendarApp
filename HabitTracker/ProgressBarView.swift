import SwiftUI
import CoreData

struct ProgressBarView: View {
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(entity: DailyHabits.entity(), sortDescriptors: []) private var dailyHabits: FetchedResults<DailyHabits>

    @State private var viewModel: ViewModel

    private var totalHabits: Int
    private var completedHabits: Int
    
    init(moc: NSManagedObjectContext, totalHabits: Int, completedHabits: Int) {
        self._viewModel = State(wrappedValue: ViewModel(moc: moc))
        self.totalHabits = totalHabits
        self.completedHabits = completedHabits
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background Bar (Uncompleted habits)
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width: geometry.size.width, height: 20)
                
                // If there are completed habits, show the progress bar
                if completedHabits > 0 {
                    ZStack {
                        // Completed Portion
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("purple")) // Use the app's purple color
                            .frame(width: (geometry.size.width) / CGFloat(max(1, totalHabits)) * CGFloat(completedHabits), height: 20)
                        
                        // Progress Text (Centered inside completed bar)
                        Text("\(completedHabits)/\(totalHabits)")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .bold))
                            .frame(width: (geometry.size.width) / CGFloat(max(1, totalHabits)) * CGFloat(completedHabits))
                            .multilineTextAlignment(.center)
                    }
                    .alignmentGuide(.leading) { _ in 0 } // Ensures it aligns to the left
                } else {
                    // Progress Text (Centered in whole bar if 0 habits completed)
                    Text("\(completedHabits)/\(totalHabits)")
                        .foregroundColor(.black)
                        .font(.system(size: 14, weight: .bold))
                        .frame(width: geometry.size.width, height: 20)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .frame(height: 20)
    }
}


struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        @Environment(\.managedObjectContext) var moc
        ProgressBarView(moc: moc, totalHabits: 10, completedHabits: 5)
    }
}
