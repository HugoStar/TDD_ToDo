//
//  ToDoItem.swift
//  TDD_ToDo
//
//  Created by Мишустин Сергеевич on 14/11/2018.
//  Copyright © 2018 LTD Zebka. All rights reserved.
//

import Foundation

struct ToDoItem {
  
  let title: String
  let itemDescription: String?
  let timestamp: Double?
  let location: Location?
  
  init(title: String,
       itemDescription: String? = nil,
       timestamp: Double? = nil,
       location: Location? = nil) {
    self.title = title
    self.itemDescription = itemDescription
    self.timestamp = timestamp
    self.location = location
  }

}

extension ToDoItem: Equatable {
  static func == (lhs: ToDoItem, rhs: ToDoItem) -> Bool {
    
    if lhs.location != rhs.location {
      return false
    }
    if lhs.timestamp != rhs.timestamp {
      return false
    }
    if lhs.itemDescription != rhs.itemDescription {
      return false
    }
    if lhs.title != rhs.title {
      return false
    }
    return true
  }
}
