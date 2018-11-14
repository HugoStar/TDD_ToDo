//
//  ItemListViewController.swift
//  TDD_ToDoTests
//
//  Created by Мишустин Сергеевич on 14/11/2018.
//  Copyright © 2018 LTD Zebka. All rights reserved.
//

import XCTest
@testable import TDD_ToDo

class ItemListViewControllerTests: XCTestCase {
  
  var sut: ItemListViewController!
  
  
  override func setUp() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: "ItemListViewController")
    sut = viewController as? ItemListViewController
    sut.loadViewIfNeeded()
  }
  
  override func tearDown() {}
  
  func test_TableView_AfterViewDidLoad_IsNotNil() {
    XCTAssertNotNil(sut.tableView)
  }
  
  func test_LoadingView_SetsTableViewDataSource() {
    XCTAssertTrue(sut.tableView.dataSource is ItemListDataProvider)
  }
  
  func test_LoadingView_SetsTableViewDelegate() {
    XCTAssertTrue(sut.tableView.delegate is ItemListDataProvider)
  }
  
  func test_LoadingView_DataSourceEqualDelegate() {
    XCTAssertEqual(sut.tableView.dataSource as? ItemListDataProvider, sut.tableView.delegate as? ItemListDataProvider)
  }
  
  
}
