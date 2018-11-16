//
//  ItemListViewController.swift
//  TDD_ToDo
//
//  Created by Мишустин Сергеевич on 14/11/2018.
//  Copyright © 2018 LTD Zebka. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet var dataProvider: (UITableViewDataSource & UITableViewDelegate)!
  
  let itemManager = ItemManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = dataProvider
    tableView.delegate = dataProvider
  }

  @IBAction func addItem(_ sender: Any) {
    
    if let nextViewController = storyboard?.instantiateViewController(withIdentifier: "InputViewController") as? InputViewController {
      nextViewController.itemManager = itemManager
      present(nextViewController, animated: true, completion: nil)
    }
    
    
  }
  

}
