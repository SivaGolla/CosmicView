//
//  CosmicViewUITests.swift
//  CosmicViewUITests
//
//  Created by Venkata Sivannarayana Golla on 01/09/24.
//

import XCTest
@testable import CosmicView_Dev

final class CosmicViewUITests: XCTestCase {

    var application: XCUIApplication!
    
    override func setUpWithError() throws {
        application = XCUIApplication()
        application.launch()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        application = nil
    }

    func testChoseAnotherDay() {
        sleep(2)

        XCTAssertTrue(application.isDisplayingHomeScreen)

        let tabBar = application.tabBars.element(boundBy: 0)
        XCTAssertTrue(tabBar.exists)
        XCTAssertTrue(tabBar.buttons["Astro Pix"].exists)
        XCTAssertTrue(tabBar.buttons["Astro Pix"].isHittable)
        
        XCTAssertTrue(tabBar.buttons["More"].exists)
        XCTAssertTrue(tabBar.buttons["More"].isHittable)
        
        let containerScrollView = application.scrollViews["containerScrollView"]
        XCTAssertTrue(containerScrollView.exists)

        sleep(2)
        
        XCTAssertTrue(application.staticTexts["mediaTitle"].exists)
        XCTAssertTrue(application.staticTexts["apodDescription"].exists)
        XCTAssertTrue(application.images["astronomyImage"].exists)
                
        
        let datePickerElement = application.datePickers["astroPixDatePicker"]
        
        XCTAssertTrue(datePickerElement.exists)

        application.tapCoordinate(at: CGPoint(x:360,y:120))

        let delayExpectation = XCTestExpectation(description: "Wait for Date Picker to Present")
        delayExpectation.isInverted = true
        wait(for: [delayExpectation], timeout: 2)
        
        let prevMonthButton = application.buttons["Previous Month"]
        
        XCTAssertTrue(prevMonthButton.exists)
        XCTAssertTrue(prevMonthButton.isHittable)
        prevMonthButton.tap()
        
        let aDateButton = application.collectionViews.element(boundBy: 0).buttons.element(boundBy: 0)
        XCTAssertTrue(aDateButton.exists)
        XCTAssertTrue(aDateButton.isHittable)
        aDateButton.tap()
        
        let expectation = XCTestExpectation(description: "Wait for Date Picker to Dismiss")
        expectation.isInverted = true
        wait(for: [expectation], timeout: 1)
        
        containerScrollView.swipeUp()
        
        let scrollExpectation = XCTestExpectation(description: "Wait for scrollview to decelerate")
        scrollExpectation.isInverted = true
        wait(for: [scrollExpectation], timeout: 1)
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
