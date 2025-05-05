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
    
    

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
