import SwiftUI
import CoreData

struct HabitView: View {
    @StateObject private var viewModel: HabitViewModel
    @Binding var selectedTab: BottomBarTabs
    @EnvironmentObject var navManager: NavigationStackManager

    init(selectedTab: Binding<BottomBarTabs>, moc: NSManagedObjectContext) {
        self._selectedTab = selectedTab
        _viewModel = StateObject(wrappedValue: HabitViewModel(moc: moc))
    }

    var body: some View {
        VStack(spacing: 0) {
            header

            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(viewModel.allHabits, id: \.objectID) { habit in
                            habitCard(for: habit)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                }
                .frame(height: geometry.size.height)
            }
        }
    }

    private var header: some View {
        Text("Habits")
            .font(.largeTitle)
            .foregroundColor(Color("grey"))
            .padding(.vertical)
    }

    private func habitCard(for habit: AllHabits) -> some View {
        Button(action: {
            navManager.push(
                HabitDetailView(
                    habit: habit,
                    habitID: habit.objectID,
                    selectedTab: $selectedTab,
                    moc: viewModel.moc
                )
            )
        }) {
            HabitViewCard(title: habit.title ?? "Unknown", color: viewModel.color(for: habit))
                .background(Color.clear.accessibilityIdentifier("HabitCard_\(habit.title ?? "Unknown")"))
        }
        .buttonStyle(PlainButtonStyle())
    }
}
