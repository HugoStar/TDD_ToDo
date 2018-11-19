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
    guard let inputViewController = getInputViewController() else { XCTFail(); return }
    XCTAssertNotNil(inputViewController.titleTextField)
  }
  
  func testItemListVC_SharesItemManagerWithInputVC() {
    guard let inputViewController = getInputViewController() else { XCTFail(); return }
    guard let inputItemManager = inputViewController.itemManager else { XCTFail(); return }
    XCTAssertTrue(sut.itemManager === inputItemManager)
  }
  
  func test_ViewDidLoad_SetsItemManagerToDataProvider() {
    XCTAssertTrue(sut.itemManager === sut.dataProvider.itemManager)
  }
  
  func test_ReloadData_WhenControllerApiar() {
    let item = ToDoItem(title: "Foo")
    sut.itemManager.add(item)
    
    let mockTableView = MockTableView()
    sut.tableView = mockTableView
    
    sut.beginAppearanceTransition(true, animated: true)
    sut.endAppearanceTransition()
    
    XCTAssertTrue(mockTableView.dataIsReload)
    
  }
  
  func test_ItemSelectedNofification_PushesDetailVC() {
    
    let mockNavigationController = MockNavigationController(rootViewController: sut)
    UIApplication.shared.keyWindow?.rootViewController = mockNavigationController
    
    sut.loadViewIfNeeded()
    sut.itemManager.add(ToDoItem(title: "foo"))
    sut.itemManager.add(ToDoItem(title: "bar"))
    
    NotificationCenter.default.post(name: NSNotification.Name("ItemSelectedNotification"), object: self, userInfo: ["index": 1])
    
    guard let detailViewController = mockNavigationController.lastPushedViewController
      as? DetailViewController else { return XCTFail() }
    
    guard let detailItemManager = detailViewController.itemInfo?.0 else { return XCTFail() }
    guard let index = detailViewController.itemInfo?.1 else { return XCTFail() }
    
    detailViewController.loadViewIfNeeded()
    
    XCTAssertNotNil(detailViewController.titleLabel)
    XCTAssertTrue(detailItemManager === sut.itemManager)
    XCTAssertEqual(index, 1)
    
  }
  
  
  
  
  
  //MARK: - Assert
  private func getInputViewController() -> InputViewController? {
    guard let addButton = sut.navigationItem.rightBarButtonItem else { XCTFail(); return nil }
    guard let action = addButton.action else { XCTFail(); return nil }
    UIApplication.shared.keyWindow?.rootViewController = sut
    
    sut.performSelector(onMainThread: action,
                        with: addButton,
                        waitUntilDone: true)
    
    guard let inputViewController = sut.presentedViewController as? InputViewController else { XCTFail(); return nil }
    return inputViewController
  }
  
  
}

extension ItemListViewControllerTests {
  
  class MockTableView: UITableView {
    var dataIsReload = false
    override func reloadData() {
      dataIsReload = true
    }
  }
  
  
  class MockNavigationController: UINavigationController {
    
    var lastPushedViewController: UIViewController?
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
      lastPushedViewController = viewController
      super.pushViewController(viewController, animated: animated)
    }
  }
}
