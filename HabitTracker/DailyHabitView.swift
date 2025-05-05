import SwiftUI
import CoreData

struct DailyHabitView: View {
    @EnvironmentObject var navManager: NavigationStackManager
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: DailyHabits.entity(), sortDescriptors: []) private var dailyHabits: FetchedResults<DailyHabits>

    let currentDate: Date
    @StateObject private var viewModel = DailyHabitViewModel()

    // FIX: Computed property for habitsForDay (just like original code)
    private var habitsForDay: [DailyHabits] {
        dailyHabits.filter { $0.date?.isSameDay(as: currentDate) ?? false }
    }

    var body: some View {
        VStack {
            header

            if habitsForDay.isEmpty {
                Text("No habits for today.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                habitsList(habitsForDay: habitsForDay)
            }

            if viewModel.showReward, let imageURL = viewModel.rewardImageURL {
                rewardView(imageURL: imageURL)
            }
        }
        .padding(.top)
        .animation(.easeInOut, value: viewModel.showReward)
        .onAppear {
            viewModel.assignColors(to: habitsForDay)
            viewModel.setContext(viewContext)
        }
    }


    private var header: some View {
        HStack {
            Button(action: { navManager.pop() }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
                    .font(.title2)
            }
            .padding(.leading)

            Spacer()

            Text(viewModel.dayOfTheWeek(from: currentDate))
                .font(.title)
                .fontWeight(.bold)

            Spacer()
        }
        .padding(.vertical)
    }

    private func habitsList(habitsForDay: [DailyHabits]) -> some View {
        List {
            ForEach(habitsForDay, id: \.id) { habit in
                HStack {
                    Text(habit.habit?.title ?? "Unknown Habit")
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Toggle("", isOn: Binding(
                        get: { habit.isCompleted },
                        set: { newValue in
                            habit.isCompleted = newValue
                            viewModel.saveContext()
                            if newValue {
                                viewModel.handleHabitCompletion()
                            }
                        }
                    ))
                    .labelsHidden()
                    .tint(viewModel.color(for: habit))
                }
                .padding(.vertical, 8)
            }
        }
        .listStyle(PlainListStyle())
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
    }

    private func rewardView(imageURL: URL) -> some View {
        VStack(spacing: 8) {
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(12)
            } placeholder: {
                ProgressView()
            }

            Text("Good job on completing a habit!")
                .font(.headline)
                .foregroundColor(.green)
        }
        .padding()
        .transition(.opacity)
    }
}
