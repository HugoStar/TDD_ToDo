//
//  ItemManager.swift
//  TDD_ToDo
//
//  Created by Мишустин Сергеевич on 14/11/2018.
//  Copyright © 2018 LTD Zebka. All rights reserved.
//

import Foundation


class ItemManager: NSObject {
  
  var toDoCount: Int { return toDoItems.count }
  var toDoneCont: Int { return toDoneItems.count }
  private var toDoItems: [ToDoItem] = []
  private var toDoneItems: [ToDoItem] = []
  
  func add(_ item: ToDoItem) {
    if !toDoItems.contains(item) {
      toDoItems.append(item)
    }
  }
  
  func item(at index: Int) -> ToDoItem {
    return toDoItems[index]
  }
  
  func checkItem(at index: Int) {
    let item = toDoItems.remove(at: index)
    toDoneItems.append(item)
  }
  
  func uncheckItem(at index: Int) {
    let item = toDoneItems.remove(at: index)
    toDoItems.append(item)
  }
  
  func doneItem(at index: Int) -> ToDoItem {
    return toDoneItems[index]
  }
  
  func removeAll() {
    toDoItems.removeAll()
    toDoneItems.removeAll()
  }
  
}
