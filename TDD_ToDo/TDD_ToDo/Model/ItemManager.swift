//
//  ItemManager.swift
//  TDD_ToDo
//
//  Created by Мишустин Сергеевич on 14/11/2018.
//  Copyright © 2018 LTD Zebka. All rights reserved.
//

import Foundation
import UIKit


class ItemManager: NSObject {
  
  var toDoCount: Int { return toDoItems.count }
  var toDoneCont: Int { return toDoneItems.count }
  private var toDoItems: [ToDoItem] = []
  private var toDoneItems: [ToDoItem] = []
  
  var toDoPathURL: URL {
    let fileURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    guard let documentURL = fileURLs.first else {
      print("Something went wrong. Documents url could not be found")
      fatalError()
    }
    
    return documentURL.appendingPathComponent("toDoItems.plist")
  }
  
  
  override init() {
    super.init()
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(save),
                                           name: UIApplication.willResignActiveNotification,
                                           object: nil)
    
    if let nsToDoItems = NSArray(contentsOf: toDoPathURL) {
      for dict in nsToDoItems {
        if let toDoItem = ToDoItem(dict: dict as! [String : Any]) {
          toDoItems.append(toDoItem)
        }
      }
    }
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
    save()
  }
  
  
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
  
  @objc func save() {
    
    let nsToDoItems = toDoItems.map { $0.plistDict }
    
    guard nsToDoItems.count > 0 else {
      try? FileManager.default.removeItem(at: toDoPathURL)
      return
    }
    
    do {
      let plistData = try PropertyListSerialization.data(fromPropertyList: nsToDoItems,
                                                         format: PropertyListSerialization.PropertyListFormat.xml,
                                                         options: PropertyListSerialization.WriteOptions(0))
      try plistData.write(to: toDoPathURL, options: Data.WritingOptions.atomic)
      
    } catch {
      print(error)
    }
    
  }
  
}
