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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = dataProvider
    tableView.delegate = dataProvider
  }



}
