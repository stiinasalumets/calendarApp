import SwiftUI
import CoreData

struct CalendarView: View {
    @Environment(\.managedObjectContext) private var moc
    @EnvironmentObject var navManager: NavigationStackManager

    @FetchRequest(entity: DailyHabits.entity(), sortDescriptors: [])
    private var dailyHabits: FetchedResults<DailyHabits>

    @StateObject private var viewModel = ViewModel()

    var body: some View {
        VStack {
            weekNavigationBar

            GeometryReader { geometry in
                VStack(spacing: 0) {
                    Spacer(minLength: 0)

                    ForEach(viewModel.weekDayColorPairs, id: \.date) { pair in
                        dayButton(pair: pair, geometry: geometry)
                    }

                    Spacer(minLength: 0)
                }
            }
            .ignoresSafeArea(edges: [.top, .bottom])
            .padding()
        }
        .onAppear {
            viewModel.initializeWeek()
        }
    }

    // MARK: - Week Navigation Bar
    private var weekNavigationBar: some View {
        HStack {
            Button(action: viewModel.goToPresent) {
                Text("Present")
                    .font(.headline)
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(8)
            }

            Button(action: viewModel.goToPreviousWeek) {
                Image(systemName: "chevron.left")
            }

            Text(viewModel.currentWeekStart.formatAsWeekRange())
                .font(.headline)

            if !viewModel.isShowingCurrentWeek {
                Button(action: viewModel.goToNextWeek) {
                    Image(systemName: "chevron.right")
                }
            }
        }
        .padding()
    }

    // MARK: - Day Button
    private func dayButton(pair: ViewModel.DayColorPair, geometry: GeometryProxy) -> some View {
        let habits = viewModel.habits(for: pair.date, in: dailyHabits)
        let totalHabits = habits.count
        let completedHabits = habits.filter { $0.isCompleted }.count

        return Button {
            navManager.push(DailyHabitView(currentDate: pair.date))
        } label: {
            HStack {
                Text("\(pair.date.formatAsDayOfWeek()) \(pair.date.formatAsDayNumber())")
                    .font(.headline)
                    .foregroundColor(Color("grey"))
                    .frame(width: geometry.size.width * 0.25, alignment: .leading)

                ProgressBarView(totalHabits: totalHabits,
                                completedHabits: completedHabits,
                                color: pair.color)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: geometry.size.height / 7)
        }
    }
}

// MARK: - Preview
struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .environmentObject(NavigationStackManager())
    }
}
