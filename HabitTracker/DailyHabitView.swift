import SwiftUI
import CoreData

struct DailyHabitView: View {
    @EnvironmentObject var navManager: NavigationStackManager
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: DailyHabits.entity(), sortDescriptors: []) private var dailyHabits: FetchedResults<DailyHabits>

    let currentDate: Date
    @StateObject private var viewModel = DailyHabitViewModel()

    private var habitsForDay: [DailyHabits] {
        dailyHabits.filter { $0.date?.isSameDay(as: currentDate) ?? false }
    }

    @State private var dragOffset = CGSize.zero
    @State private var isRewardVisible = false  // Start with the reward hidden
    @State private var isSwipeToHideEnabled = true // Control swipe-to-hide behavior

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

            if viewModel.showReward, let imageURL = viewModel.rewardImageURL, isRewardVisible {
                rewardView(imageURL: imageURL)
                    .offset(y: dragOffset.height)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if value.translation.height > 0 {
                                    dragOffset = value.translation
                                }
                            }
                            .onEnded { value in
                                if dragOffset.height > 100 {  // Threshold for swipe-down to hide the image
                                    withAnimation {
                                        isRewardVisible = false
                                    }
                                }
                                dragOffset = .zero
                            }
                    )
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
                                // Make the reward image visible when the habit is marked as completed
                                isRewardVisible = true
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
