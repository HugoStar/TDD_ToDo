//
//  ItemCell.swift
//  TDD_ToDo
//
//  Created by Мишустин Сергеевич on 15/11/2018.
//  Copyright © 2018 LTD Zebka. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
  
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  lazy var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    return dateFormatter
  }()
  

  func configCell(with item: ToDoItem, checked: Bool = false) {
    
    if checked {
      let attributedString = NSAttributedString(string: item.title, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
      titleLabel.attributedText = attributedString
      locationLabel.text = nil
      dateLabel.text = nil
    } else {
      titleLabel.text = item.title
      if let timestamp = item.timestamp {
        let date = Date(timeIntervalSince1970: timestamp)
        dateLabel.text = dateFormatter.string(from: date)
      }
      if let location = item.location {
        locationLabel.text = location.name
      }
    }
  }
}
