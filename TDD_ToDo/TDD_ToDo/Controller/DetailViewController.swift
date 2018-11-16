//
//  DetailViewController.swift
//  TDD_ToDo
//
//  Created by Мишустин Сергеевич on 15/11/2018.
//  Copyright © 2018 LTD Zebka. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
  
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  @IBOutlet var mapView: MKMapView!
  
  var itemInfo: (itemManager: ItemManager, currentItem: Int)?
  
  let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    return dateFormatter
  }()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    guard  let itemInfo = itemInfo else { return }
    let item = itemInfo.itemManager.item(at: itemInfo.currentItem)
    titleLabel.text = item.title
    locationLabel.text = item.location?.name
    descriptionLabel.text = item.itemDescription
    if let timestamp = item.timestamp {
      let date = Date(timeIntervalSince1970: timestamp)
      dateLabel.text = dateFormatter.string(from: date)
    }
    if let coordinate = item.location?.coordinate {
      let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
      mapView.region = region
    }
  }
  
  func checkItem() {
    if let itemInfo = itemInfo {
      itemInfo.itemManager.checkItem(at: itemInfo.currentItem)
    }
  }

}
