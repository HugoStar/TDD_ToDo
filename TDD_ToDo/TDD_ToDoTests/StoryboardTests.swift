//
//  StoryboardTests.swift
//  TDD_ToDoTests
//
//  Created by Мишустин Сергеевич on 16/11/2018.
//  Copyright © 2018 LTD Zebka. All rights reserved.
//

import XCTest
@testable import TDD_ToDo

class StoryboardTests: XCTestCase {

    override func setUp() {}

    override func tearDown() {}
  
  
  func testInitialViewController_IsItemListViewController() {
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
    let rootViewController = navigationController.viewControllers[0]
    
    XCTAssertTrue(rootViewController is ItemListViewController)
  }


}
