import SwiftUI
import CoreData

struct DailyHabitView: View {
    @EnvironmentObject var navManager: NavigationStackManager
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: DailyHabits.entity(), sortDescriptors: []) private var dailyHabits: FetchedResults<DailyHabits>

    let currentDate: Date

    @State private var showReward = false
    @State private var rewardImageURL: URL?

    var dayOfTheWeek: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"
        return dateFormatter.string(from: currentDate)
    }

    var body: some View {
        VStack {
            HStack {
                Button(action: { navManager.pop() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .font(.title2)
                }
                .padding(.leading)

                Spacer()

                Text(dayOfTheWeek)
                    .font(.title)
                    .fontWeight(.bold)

                Spacer()
            }
            .padding(.vertical)

            let habitsForDay = dailyHabits.filter { $0.date?.isSameDay(as: currentDate) ?? false }

            if habitsForDay.isEmpty {
                Text("No habits for today.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(habitsForDay, id: \.id) { habit in
                        HStack {
                            Text(habit.habit?.title ?? "Unknown Habit")
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Toggle("", isOn: Binding(
                                get: { habit.isCompleted },
                                set: { newValue in
                                    habit.isCompleted = newValue
                                    saveContext()
                                    if newValue {
                                        handleHabitCompletion()
                                    }
                                }
                            ))
                            .labelsHidden()
                        }
                        .padding(.vertical, 8)
                    }
                }
                .listStyle(PlainListStyle())
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
            }

            if showReward, let imageURL = rewardImageURL {
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
        .padding(.top)
        .animation(.easeInOut, value: showReward)
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Failed to save habit completion: \(error)")
        }
    }

    private func handleHabitCompletion() {
        fetchRewardImage()
    }

    private func fetchRewardImage() {
        let settingsRequest: NSFetchRequest<Settings> = Settings.fetchRequest()
        settingsRequest.fetchLimit = 1

        guard let settings = try? viewContext.fetch(settingsRequest).first else {
            print("Settings not found")
            return
        }

        let isDogPerson = settings.dogPerson
        let isCatPerson = settings.catPerson

        // Determine which animal to fetch
        let fetchCat = (isCatPerson && !isDogPerson) ||
                       (isCatPerson && isDogPerson && Bool.random())

        if fetchCat {
            fetchCatImage()
        } else {
            fetchDogImage()
        }
    }
    
    private func fetchCatImage() {
        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]],
               let first = json.first,
               let urlString = first["url"] as? String,
               let imageURL = URL(string: urlString) {
                DispatchQueue.main.async {
                    self.rewardImageURL = imageURL
                    self.showReward = true

                    DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                        self.showReward = false
                    }
                }
            } else if let error = error {
                print("Error fetching cat image: \(error)")
            }
        }.resume()
    }

    private func fetchDogImage() {
        guard let url = URL(string: "https://dog.ceo/api/breeds/image/random") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let imageURLString = json["message"] as? String,
               let imageURL = URL(string: imageURLString) {
                DispatchQueue.main.async {
                    self.rewardImageURL = imageURL
                    self.showReward = true

                    DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                        self.showReward = false
                    }
                }
            } else if let error = error {
                print("Error fetching dog image: \(error)")
            }
        }.resume()
    }


}
