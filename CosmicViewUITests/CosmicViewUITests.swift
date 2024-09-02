//
//  CosmicViewUITests.swift
//  CosmicViewUITests
//
//  Created by Venkata Sivannarayana Golla on 01/09/24.
//

import XCTest

final class CosmicViewUITests: XCTestCase {

    var application: XCUIApplication!
    
    
    override func setUpWithError() throws {
        application = XCUIApplication()
        application.launch()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testChoseAnotherDay() {
        
        XCTAssertTrue(application.isDisplayingHomeScreen)
        
        //XCTAssertTrue(application.staticTexts["mediaTitle"].exists)
        XCTAssertTrue(application.images["astronomyImage"].exists)
        //XCTAssertTrue(application.textViews["mediaExplaination"].exists)
        
        XCTAssertTrue(application.datePickers["astroPixDatePicker"].exists)
        
        // work around: coordinates used and works only in iPhone 13 Max Pro considering issues with date picker automation
        application.tapCoordinate(at: CGPoint(x:360,y:120))
        
        let delayExpectation = XCTestExpectation(description: "Wait for Date Picker to Present")
        delayExpectation.isInverted = true
        wait(for: [delayExpectation], timeout: 1)
        
        application.tapCoordinate(at: CGPoint(x:360,y:250))
        // Changing date automation not working - Compact DatePicker selection seems having issues with automation
//        application.datePickers.collectionViews.buttons["Friday, March 25"].otherElements.containing(.staticText, identifier:"25").element.tap()
        
        application.tapCoordinate(at: CGPoint(x:360,y:120))
        
        let expectation = XCTestExpectation(description: "Wait for Date Picker to Dismiss")
        expectation.isInverted = true
        wait(for: [expectation], timeout: 1)
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

extension XCUIApplication {
    var isDisplayingHomeScreen: Bool {
        return otherElements["homeView"].exists
    }
    
    func tapCoordinate(at point: CGPoint) {
        let normalized = coordinate(withNormalizedOffset: .zero)
        let offset = CGVector(dx: point.x, dy: point.y)
        let coordinate = normalized.withOffset(offset)
        coordinate.tap()
    }
}

extension Date {
    
    static func from(year: Int,
                     month: Int,
                     day: Int,
                     hour: Int,
                     minute: Int) -> Date {
        
        let dateComponents = DateComponents(
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute
        )
        
        return Calendar(identifier: .gregorian).date(from: dateComponents)!
    }
    
}
