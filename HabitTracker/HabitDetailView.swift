import SwiftUI
import CoreData

struct HabitDetailView: View {
    @EnvironmentObject var navManager: NavigationStackManager
    @ObservedObject private var viewModel = HabitDetailViewModel()

    let habit: AllHabits
    let habitID: NSManagedObjectID
    let moc: NSManagedObjectContext
    @Binding var selectedTab: BottomBarTabs

    init(habit: AllHabits, habitID: NSManagedObjectID, selectedTab: Binding<BottomBarTabs>, moc: NSManagedObjectContext) {
        self.habit = habit
        self.habitID = habitID
        self.moc = moc
        self._selectedTab = selectedTab
    }

    var body: some View {
        VStack {
            headerView
            daysListView
            actionButtons
        }
        .onAppear {
            viewModel.configureDays(from: habit.interval)
        }
    }

    // MARK: - Subviews

    private var headerView: some View {
        VStack {
            HStack {
                backButton
                Spacer()
            }
            .overlay(
                Text(habit.title ?? "Unknown")
                    .font(.largeTitle)
                    .foregroundColor(Color("grey"))
                    .padding(.top),
                alignment: .center
            )
            .padding(.vertical)
        }
    }

    private var backButton: some View {
        Button(action: { navManager.pop() }) {
            Image(systemName: "chevron.left")
                .foregroundColor(Color("grey"))
                .font(.title2)
        }
        .padding([.leading, .top])
    }

    private var daysListView: some View {
        List(viewModel.sortedDays, id: \.self) { day in
            Text(day)
        }
    }

    private var actionButtons: some View {
        HStack {
            deleteButton
            Spacer()
            editButton
        }
        .padding()
    }

    private var deleteButton: some View {
        Button(action: {
            navManager.push(deleteView(selectedTab: $selectedTab, moc: moc, habitID: habitID, title: habit.title ?? ""))
        }) {
            labelWithIcon(text: "Delete", systemImage: "trash")
        }
    }

    private var editButton: some View {
        Button(action: {
            navManager.push(
                EditView(
                    selectedTab: $selectedTab,
                    moc: moc,
                    title: habit.title ?? "",
                    selectedDays: viewModel.selectedDays,
                    habitID: habitID
                )
            )
        }) {
            labelWithIcon(text: "Edit", systemImage: "pencil")
        }
    }

    private func labelWithIcon(text: String, systemImage: String) -> some View {
        HStack {
            Text(text)
                .foregroundColor(Color("grey"))
                .font(.body)
            Image(systemName: systemImage)
                .foregroundColor(Color("grey"))
                .font(.body)
        }
    }
}
