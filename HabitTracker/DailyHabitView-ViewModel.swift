import SwiftUI
import CoreData

final class DailyHabitViewModel: ObservableObject {
    @Published var showReward = false
    @Published var rewardImageURL: URL?

    private var habitColors: [UUID: String] = [:]
    private let themeColorController = ThemeColorController()
    private var viewContext: NSManagedObjectContext?

    func setContext(_ context: NSManagedObjectContext) {
        self.viewContext = context
    }

    func dayOfTheWeek(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: date)
    }

    func assignColors(to habits: [DailyHabits]) {
        var previousColor = ""
        var updatedColors: [UUID: String] = [:]

        for habit in habits {
            guard let id = habit.id else { continue }
            let color = themeColorController.randomColorInList(prevColor: previousColor)
            updatedColors[id] = color
            previousColor = color
        }

        habitColors = updatedColors
    }

    func color(for habit: DailyHabits) -> Color {
        guard let id = habit.id, let colorName = habitColors[id] else {
            return .blue
        }
        return Color(colorName)
    }

    func saveContext() {
        guard let context = viewContext else { return }
        do {
            try context.save()
        } catch {
            print("Failed to save habit completion: \(error)")
        }
    }

    func handleHabitCompletion() {
        fetchRewardImage()
    }

    private func fetchRewardImage() {
        guard let context = viewContext else { return }

        let request: NSFetchRequest<Settings> = Settings.fetchRequest()
        request.fetchLimit = 1

        guard let settings = try? context.fetch(request).first else {
            print("Settings not found")
            return
        }

        let isDogPerson = settings.dogPerson
        let isCatPerson = settings.catPerson

        let fetchCat = (isCatPerson && !isDogPerson) || (isCatPerson && isDogPerson && Bool.random())

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
                self.displayRewardImage(imageURL)
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
                self.displayRewardImage(imageURL)
            } else if let error = error {
                print("Error fetching dog image: \(error)")
            }
        }.resume()
    }

    private func displayRewardImage(_ imageURL: URL) {
        DispatchQueue.main.async {
            self.rewardImageURL = imageURL
            self.showReward = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                self.showReward = false
            }
        }
    }
}
