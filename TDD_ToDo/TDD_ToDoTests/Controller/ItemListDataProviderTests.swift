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
  
  var sut: ItemListDataProvider!
  var tableView: UITableView!
  var controller: ItemListViewController!
  
  override func setUp() {
    sut = ItemListDataProvider()
    sut.itemManager = ItemManager()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    controller = storyboard.instantiateViewController(withIdentifier: "ItemListViewController") as? ItemListViewController
    controller.loadViewIfNeeded()
    
    tableView = UITableView()
    tableView.dataSource = sut
    tableView.delegate = sut
  }
  
  override func tearDown() {
    sut.itemManager?.removeAll()
  }
  
  func test_NumberOfSections_IsTwo() {
    let numberOfSection = tableView.numberOfSections
    
    XCTAssertEqual(numberOfSection, 2)
  }
  
  func test_NumberOfRows_Section1_IsToDoCount() {

    sut.itemManager?.add(ToDoItem(title: "Foo"))
    XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
    
    sut.itemManager?.add(ToDoItem(title: "Bar"))
    tableView.reloadData()
    XCTAssertEqual(tableView.numberOfRows(inSection: 0), 2)
  }
  
  func test_NumberOfRows_Section2_IsToDoneCount() {

    sut.itemManager?.add(ToDoItem(title: "Foo"))
    sut.itemManager?.add(ToDoItem(title: "Bar"))
    sut.itemManager?.checkItem(at: 0)
    
    XCTAssertEqual(tableView.numberOfRows(inSection: 1), 1)
    
    sut.itemManager?.checkItem(at: 0)
    tableView.reloadData()
    XCTAssertEqual(tableView.numberOfRows(inSection: 1), 2)
  }
  
  func test_CellForRow_RerurnsItemsCell() {
    sut.itemManager?.add(ToDoItem(title: "Foo"))
    tableView.reloadData()
    
    let cell = ItemCell()
    XCTAssertNotNil(cell)
  }
  
  func test_CellForRow_DequeuesCellFromTableView() {
    let mockTableView = MockTableView.mockTableView(withDataSource: sut)
    sut.itemManager?.add(ToDoItem(title: "Foo"))
    mockTableView.reloadData()
    
    _ = mockTableView.cellForRow(at: IndexPath(row: 0, section: 0))
    
    XCTAssertTrue(mockTableView.cellGotDequeued)
  }
  
  func test_CellForRow_CallsConfigCell() {
    let mockTableView = MockTableView.mockTableView(withDataSource: sut)
    
    let item = ToDoItem(title: "Foo")
    sut.itemManager?.add(item)
    mockTableView.reloadData()
    
    let cell = mockTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MockItemCell
    
    XCTAssertEqual(cell.cathedItem, item)
  }
  
  func test_CellForRow_Section2_CallsConfigCellWithDoneItem() {
    let mockTableView = MockTableView.mockTableView(withDataSource: sut)
    
    sut.itemManager?.add(ToDoItem(title: "Foo"))
    
    let second = ToDoItem(title: "Bar")
    sut.itemManager?.add(second)
    sut.itemManager?.checkItem(at: 1)
    mockTableView.reloadData()
    
    let cell = mockTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! MockItemCell
    XCTAssertEqual(cell.cathedItem, second)
  }
  
  func test_DeleteButton_InFirstSection_ShowTitleCheck() {
    let deleteButtonTitle = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section: 0))
    
    XCTAssertEqual(deleteButtonTitle, "Check")
  }
  
  func test_DeleteButton_InSecondSection_ShowstitleUncheck() {
    let deleteButtonTitle = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section: 1))
    
    XCTAssertEqual(deleteButtonTitle, "Uncheck")
  }
  
  func test_CheckingAnItem_ChecksItInTheItemManager() {
    sut.itemManager?.add(ToDoItem(title: "Foo"))
    tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 0))
    
    XCTAssertEqual(sut.itemManager?.toDoCount, 0)
    XCTAssertEqual(sut.itemManager?.toDoneCont, 1)
    XCTAssertEqual(tableView.numberOfRows(inSection: 0), 0)
    XCTAssertEqual(tableView.numberOfRows(inSection: 1), 1)
  }
  
  func test_UncheckingAnItem_UnchecksItInTheItemManager() {
    
    sut.itemManager?.add(ToDoItem(title: "First"))
    sut.itemManager?.checkItem(at: 0)
    tableView.reloadData()
    tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 1))
    
    XCTAssertEqual(sut.itemManager?.toDoCount, 1)
    XCTAssertEqual(sut.itemManager?.toDoneCont, 0)
    XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
    XCTAssertEqual(tableView.numberOfRows(inSection: 1), 0)
    
    
  }
  
  
  func test_SelectionACell_SendsNotification() {
    
    let item = ToDoItem(title: "First")
    sut.itemManager?.add(item)
    
    expectation(forNotification: NSNotification.Name(rawValue: "ItemSelectedNotification"), object: nil) { notification in
      guard let index = notification.userInfo?["index"] as? Int else { return false }
      return index == 0
    }
    
    tableView.delegate?.tableView!(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
    
    waitForExpectations(timeout: 3, handler: nil)
    
  }
  
  
  
}

//Mocks
extension ItemListDataProviderTests {
  
  class MockTableView: UITableView {
    var cellGotDequeued = false
    override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
      cellGotDequeued = true
      return super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }
    
    
    class func mockTableView(withDataSource dataSource: UITableViewDataSource) -> MockTableView {
      
      let mockTableView = MockTableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480), style: .plain)
      
      mockTableView.dataSource = dataSource
      mockTableView.register(MockItemCell.self, forCellReuseIdentifier: "ItemCell")
      
      return mockTableView
    }
    
  }
  
  class MockItemCell: ItemCell {
    var cathedItem: ToDoItem?
    override func configCell(with item: ToDoItem, checked: Bool) {
      cathedItem = item
    }
  }
  
  
}
