//
//  ItemManagerTests.swift
//  TDD_ToDoTests
//
//  Created by Мишустин Сергеевич on 14/11/2018.
//  Copyright © 2018 LTD Zebka. All rights reserved.
//

import XCTest
@testable import TDD_ToDo

class ItemManagerTests: XCTestCase {
  
  var sut: ItemManager!

    override func setUp() {
      sut = ItemManager()
    }

    override func tearDown() {}
  
  
  func test_ToDoCount_Initially_IsZero() {
    XCTAssertEqual(sut.toDoCount, 0)
  }
  
  func test_ToDownCount_Initially_IsZero() {
    XCTAssertEqual(sut.toDoneCont, 0)
  }
  
  func test_AddItem_IncreasesToDoCountToOne() {
    sut.add(ToDoItem(title: ""))
    
    XCTAssertEqual(sut.toDoCount, 1, "sut don't add element")
  }
  
  func test_ItemAt_ReturnsAddedItem(){
    let item = ToDoItem(title: "Foo")
    sut.add(item)
    let returnedItem = sut.item(at: 0)
    
    XCTAssertEqual(returnedItem.title, item.title)
  }
  
  func test_ChackItemAt_ChangesCounts() {
    sut.add(ToDoItem(title: ""))
    sut.checkItem(at: 0)
    
    XCTAssertEqual(sut.toDoCount, 0)
    XCTAssertEqual(sut.toDoneCont, 1)
  }
  
  func test_CheckItemAt_RemovesItFromToDoItems() {
    let first = ToDoItem(title: "First")
    let second = ToDoItem(title: "Second")
    sut.add(first)
    sut.add(second)
    sut.checkItem(at: 0)
    
    XCTAssertEqual(sut.item(at: 0).title, "Second")
  }
  
  func test_DoneItemAt_ReturnsCheckedItem() {
    let item = ToDoItem(title: "Foo")
    sut.add(item)
    sut.checkItem(at: 0)
    let returnedItem = sut.doneItem(at: 0)
    
    XCTAssertEqual(returnedItem.title, "Foo")
  }
  
  func test_RemoveAll_ResultsInCountsBeZero() {
    sut.add(ToDoItem(title: "Foo"))
    sut.add(ToDoItem(title: "Bar"))
    sut.checkItem(at: 0)
    
    XCTAssertEqual(sut.toDoCount, 1)
    XCTAssertEqual(sut.toDoneCont, 1)
    
    sut.removeAll()
    
    XCTAssertEqual(sut.toDoCount, 0)
    XCTAssertEqual(sut.toDoneCont, 0)
  }
  
  func test_AddWhenItemIsAlreadyAdded_DoesNotIncreaseCount() {
    sut.add(ToDoItem(title: "Foo"))
    sut.add(ToDoItem(title: "Foo"))
    
    XCTAssertNotEqual(sut.toDoneCont, 1)
  }

}
