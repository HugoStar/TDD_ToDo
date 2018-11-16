//
//  ItemCellTests.swift
//  TDD_ToDoTests
//
//  Created by Мишустин Сергеевич on 15/11/2018.
//  Copyright © 2018 LTD Zebka. All rights reserved.
//

import XCTest
@testable import TDD_ToDo

class ItemCellTests: XCTestCase {
  
  var tableView: UITableView!
  let dataSource = FakeDataSource()
  var cell: ItemCell!
  
  override func setUp() {
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let controller = storyboard.instantiateViewController( withIdentifier: "ItemListViewController") as! ItemListViewController
    controller.loadViewIfNeeded()
    tableView = controller.tableView
    tableView?.dataSource = dataSource
    cell = tableView?.dequeueReusableCell(withIdentifier: "ItemCell", for: IndexPath(row: 0, section: 0)) as? ItemCell
  }
  
  override func tearDown() {}
  
  func test_HasNameLabel() {
    XCTAssertTrue(cell.titleLabel.isDescendant(of: cell.contentView))
  }
  
  func test_HasLocationLabel() {
    XCTAssertTrue(cell.locationLabel.isDescendant(of: cell.contentView))
  }
  
  func test_HasDateLabel() {
    XCTAssertTrue(cell.dateLabel.isDescendant(of: cell.contentView))
  }
  
  func testConfigCell_SetTitle() {
    cell.configCell(with: ToDoItem(title: "Foo"))
    
    XCTAssertEqual(cell.titleLabel.text, "Foo")
  }
  
  func test_ConfigeCell_SetDate() {
    let date = cell.dateFormatter.date(from: "08/27/2017")
    let timestamp = date?.timeIntervalSince1970
    cell.configCell(with: ToDoItem(title: "Foo", timestamp: timestamp))
    
    XCTAssertEqual(cell.dateLabel.text, "08/27/2017")
  }
  
  func test_ConfigeCell_SetLocation() {
    let location = Location(name: "Bar")
    cell.configCell(with: ToDoItem(title: "Foo", location: location))
    
    XCTAssertEqual(cell.locationLabel.text, "Bar")
  }
  
  func test_Title_WhenItemIsChecked_IsStrokeThrough() {
    
    let location = Location(name: "Bar")
    let item = ToDoItem(title: "Foo",
                        itemDescription: nil,
                        timestamp: 1456150025,
                        location: location)
    
    cell.configCell(with: item, checked: true)
    
    let attributedString = NSAttributedString(string: "Foo", attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
    
    XCTAssertEqual(cell.titleLabel.attributedText, attributedString)
    XCTAssertNil(cell.locationLabel.text)
    XCTAssertNil(cell.dateLabel.text)
    
  }
  
  
  
  
  
  
}

extension ItemCellTests {
  
  class FakeDataSource: NSObject, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      return UITableViewCell()
    }
  }
}
