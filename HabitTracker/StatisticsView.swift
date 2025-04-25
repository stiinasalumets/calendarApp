import SwiftUI
import CoreData

struct StatisticsView: View {
    @Environment(\.managedObjectContext) private var moc
    @State private var viewModel: ViewModel
    
    
    
    init(moc: NSManagedObjectContext) {
        self._viewModel = State(wrappedValue: ViewModel(moc: moc))
    }
    
    var body: some View {
        VStack{
            VStack {
                Text("Statistics")
                    .font(.largeTitle)
                    .foregroundColor(Color("grey"))
                    .padding(.top)
                
            }
            
            VStack(alignment: .center, spacing: 4) {
                Text("Streak")
                    .font(.title3)
                    
                Text("\(viewModel.habitStreak) days")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 8)
            
            List {
                Section(header: Text("Current habits")) {
                    ForEach(viewModel.habitStatsActive.sorted(by: { $0.key.title ?? "" < $1.key.title ?? "" }), id: \.key) { habit, percentage in
                        HStack {
                            Text(habit.title ?? "Unnamed Habit")
                            Spacer()
                            Text("\(percentage)%")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                Section(header: Text("Former Habits")) {
                    ForEach(viewModel.habitStats.sorted(by: { $0.key.title ?? "" < $1.key.title ?? "" }), id: \.key) { habit, percentage in
                        HStack {
                            Text(habit.title ?? "Unnamed Habit")
                            Spacer()
                            Text("\(percentage)%")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            
            
            
        }
    }
}
