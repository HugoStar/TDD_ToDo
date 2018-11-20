//
//  TDD_ToDoUITests.swift
//  TDD_ToDoUITests
//
//  Created by Мишустин Сергеевич on 20/11/2018.
//  Copyright © 2018 LTD Zebka. All rights reserved.
//

import XCTest

class TDD_ToDoUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
      
      
      let app = XCUIApplication()
      app.navigationBars["TDD_ToDo.ItemListView"].buttons["Add"].tap()
      app.textFields["Title"].tap()
      app.textFields["Title"].typeText("Meeting")
      app.textFields["Date"].tap()
      app.textFields["Date"].typeText("02/22/2018")
      app.textFields["Location"].tap()
      app.textFields["Location"].typeText("Office")
      app.textFields["Address"].tap()
      app.textFields["Address"].typeText("Infinite Loop 1, Cupertino")
      app.textFields["Description"].tap()
      app.textFields["Description"].typeText("Bring iPad")
      app.buttons["Save"].tap()
 
      
    }

}
