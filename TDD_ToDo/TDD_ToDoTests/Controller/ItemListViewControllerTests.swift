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
  
  func test_ItemListViewController_HasAddBarButtonWihtSelfAsTarget() {
    let target = sut.navigationItem.rightBarButtonItem?.target
    XCTAssertEqual(target as? UIViewController, sut)
  }
  
  func test_AddItem_PresentAddItemViewController() {
    guard let inputViewController = checkOnNilPresentViewController() else { XCTFail(); return }
    XCTAssertNotNil(inputViewController.titleTextField)
    
  }
  
  func testItemListVC_SharesItemManagerWithInputVC() {
    guard let inputViewController = checkOnNilPresentViewController() else { XCTFail(); return }
    guard let inputItemManager = inputViewController.itemManager else { XCTFail(); return }
    XCTAssertTrue(sut.itemManager === inputItemManager)
  }
  
  //MARK: - Assert
  private func checkOnNilPresentViewController() -> InputViewController? {
    XCTAssertNil(sut.presentedViewController)
    
    guard let addButton = sut.navigationItem.rightBarButtonItem else { XCTFail(); return nil }
    guard let action = addButton.action else { XCTFail(); return nil }
    UIApplication.shared.keyWindow?.rootViewController = sut
    
    sut.performSelector(onMainThread: action, with: addButton, waitUntilDone: true)
    
    guard let inputViewController = sut.presentedViewController as? InputViewController else { XCTFail(); return nil }
    XCTAssertNotNil(sut.presentedViewController)
    return inputViewController
  }
  
  
}
