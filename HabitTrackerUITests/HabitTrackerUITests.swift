import XCTest

final class HabitTrackerUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddHabit() throws {
        
        let app = XCUIApplication()
        app.launch()
        
        //Tap the + button in bottom bar
        app.buttons["Add"].tap()
        
        //Enter habit title
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        elementsQuery.textFields["Title"].tap()
        
        app.keys["N"].tap()
        app.keys["e"].tap()
        app.keys["w"].tap()
        
        app/*@START_MENU_TOKEN@*/.keys["Mellemrum"]/*[[".keyboards.keys[\"Mellemrum\"]",".keys[\"Mellemrum\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.keys["h"].tap()
        app.keys["a"].tap()
        app.keys["b"].tap()
        app.keys["i"].tap()
        app.keys["t"].tap()
        
        //Select weekdays
        scrollViewsQuery.otherElements.containing(.staticText, identifier:"Title").element.tap()
        let titleElement = scrollViewsQuery.otherElements.containing(.staticText, identifier:"Title").element
        scrollViewsQuery.images["TuesdayCheckbox"].tap()
        
        //Save new habit
        elementsQuery.buttons["Save"].tap()
        
        //Verify habit appears in list
        let habitCard = app.otherElements["HabitCard_New habit"]
        app.scrollViews.firstMatch.swipeUp()
        
        sleep(2)
        
        XCTAssertTrue(habitCard.exists)
        
        //Click the habit
        app.otherElements["HabitCard_New habit"].tap()
        
        //Verify that Tuesday was added
        sleep(1)
        
        let tuesdayLabel = app.staticTexts["Tuesday"]
        XCTAssertTrue(tuesdayLabel.exists)
    }
    
    func testAllActiveHabitsAreDisplayedAndInactiveHabitsAreHidden() throws {
            let app = XCUIApplication()
            app.launch()

            // Give the UI some time to load the habits list
            sleep(2)

            // List of all active habits (from your provided JSON)
            let activeHabitTitles = [
                "Morning Run", "Read a Book", "Yoga", "Write Journal",
                "Grocery Shopping", "Learning a New Language", "Evening Walk",
                "Stretching", "Drink More Water", "Clean Workspace", "Plan Tomorrow",
                "Check Budget", "Read News", "Tidy Up Room", "Journal Gratitude",
                "Listen to Podcast", "Social Media Detox", "Practice Coding",
                "Do a Good Deed", "Skincare Routine"
            ]

            // List of all inactive habits
            let inactiveHabitTitles = [
                "Meditation", "Workout", "Call Family",
                "Cooking Experiment", "Declutter One Item"
            ]

            // Scroll a few times to ensure all items load (basic pagination insurance)
            let scrollView = app.scrollViews.firstMatch
            scrollView.swipeUp()
            scrollView.swipeUp()
            scrollView.swipeUp()
            
            sleep(1)

            // Assert all active habits are displayed
            for title in activeHabitTitles {
                let element = app.otherElements["HabitCard_\(title)"]
                XCTAssertTrue(element.exists, "Active habit '\(title)' should be displayed.")
            }

            // Assert no inactive habits are displayed
            for title in inactiveHabitTitles {
                let element = app.otherElements["HabitCard_\(title)"]
                XCTAssertFalse(element.exists, "Inactive habit '\(title)' should NOT be displayed.")
            }
        }
    
    

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}


