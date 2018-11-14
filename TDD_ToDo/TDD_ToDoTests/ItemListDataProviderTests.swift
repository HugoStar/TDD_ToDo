//
//  ItemListDataProviderTests.swift
//  TDD_ToDoTests
//
//  Created by Мишустин Сергеевич on 14/11/2018.
//  Copyright © 2018 LTD Zebka. All rights reserved.
//

import XCTest
@testable import TDD_ToDo

class ItemListDataProviderTests: XCTestCase {
  
  override func setUp() {}
  
  override func tearDown() {}
  
  func test_NumberOfSections_IsTwo() {
    
    let sut = ItemListDataProvider()
    
    let tableView = UITableView()
    tableView.dataSource = sut
    
    let numberOfSection = tableView.numberOfSections
    
    XCTAssertEqual(numberOfSection, 2)
    
  }
  
  
}
