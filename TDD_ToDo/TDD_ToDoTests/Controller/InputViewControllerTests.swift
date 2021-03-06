//
//  InputViewControllerTests.swift
//  TDD_ToDoTests
//
//  Created by Мишустин Сергеевич on 15/11/2018.
//  Copyright © 2018 LTD Zebka. All rights reserved.
//

import XCTest
import CoreLocation
@testable import TDD_ToDo

class InputViewControllerTests: XCTestCase {
  
  var sut: InputViewController!
  var placemark: MockPlacemark!
  
  override func setUp() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    sut = storyboard.instantiateViewController(withIdentifier: "InputViewController") as? InputViewController
    sut.loadViewIfNeeded()
  }
  
  override func tearDown() {}
  
  func test_HasTitleTextField() {
    XCTAssertTrue(sut.titleTextField.isDescendant(of: sut.view))
  }
  
  func test_HasDateTextField() {
    XCTAssertTrue(sut.dateTextField.isDescendant(of: sut.view))
  }
  
  func test_HasLocationTextField() {
    XCTAssertTrue(sut.locationTextField.isDescendant(of: sut.view))
  }
  
  func test_HasAddressTextField() {
    XCTAssertTrue(sut.addressTextField.isDescendant(of: sut.view))
  }
  
  func test_HasDescriptionTextField() {
    XCTAssertTrue(sut.descriptionTextField.isDescendant(of: sut.view))
  }
  
  func test_HasSaveButton() {
    XCTAssertTrue(sut.saveButton.isDescendant(of: sut.view))
  }
  
  func test_HasCancelButton() {
    XCTAssertTrue(sut.cancelButton.isDescendant(of: sut.view))
  }
  
  func test_CheckCurrentTitleSaveButton() {
    XCTAssertTrue(sut.saveButton.currentTitle == "Save")
  }
  
  func test_CheckCurrentTitleCancelButton() {
    XCTAssertTrue(sut.cancelButton.currentTitle == "Cancel")
  }
  
  func test_Save_UsesGeocoderToGetCoordinateFromAddress() {
    let mockSut = MockInputViewController()
    
    mockSut.titleTextField = UITextField()
    mockSut.dateTextField = UITextField()
    mockSut.locationTextField = UITextField()
    mockSut.addressTextField = UITextField()
    mockSut.descriptionTextField = UITextField()
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    
    let timestamp = 1456088400.0
    let date = Date(timeIntervalSince1970: timestamp)
    
    mockSut.titleTextField.text = "Foo"
    mockSut.dateTextField.text = dateFormatter.string(from: date)
    mockSut.locationTextField.text = "Bar"
    mockSut.addressTextField.text = "Infinite Loop 1, Cupertino"
    mockSut.descriptionTextField.text = "Baz"
    
    let mockGeocoder = MockGeocoder()
    mockSut.geocoder = mockGeocoder
    
    mockSut.itemManager = ItemManager()
    
    let dismissExpectation = expectation(description: "Dismiss")
    
    mockSut.completionHandler = {
      dismissExpectation.fulfill()
    }
    
    mockSut.save()
    
    placemark = MockPlacemark()
    let coordinate = CLLocationCoordinate2DMake(37.3316851,
                                                -122.0300674)
    placemark.mockCoordinate = coordinate
    mockGeocoder.completionHandler?([placemark], nil)
    
    waitForExpectations(timeout: 1, handler: nil)
    
    let item = mockSut.itemManager?.item(at: 0)
    
    let testItem = ToDoItem(title: "Foo",
                            itemDescription: "Baz",
                            timestamp: timestamp,
                            location: Location(name: "Bar",
                                               coordinate: coordinate))

    
    XCTAssertEqual(item, testItem)
    mockSut.itemManager?.removeAll()
  }
  
  func test_SaveButtonHasSaveAction() {
    let saveButton: UIButton = sut.saveButton
    guard let actions = saveButton.actions(forTarget: sut, forControlEvent: .touchUpInside) else { XCTFail(); return }
    XCTAssertTrue(actions.contains("save"))
  }
  
  
  func test_Geocoder_FetchesCoordinates() {
    
    let geocoderAnswered = expectation(description: "Geocoder")
    let address = "Infinite Loop 1, Cupertino"
    CLGeocoder().geocodeAddressString(address) { placemarks, error in
      
      let coordinate = placemarks?.first?.location?.coordinate
      
      guard let latitude = coordinate?.latitude else { XCTFail(); return }
      guard let longitude = coordinate?.longitude else { XCTFail(); return }
      
      XCTAssertEqual(latitude, 37.3316, accuracy: 0.001)
      XCTAssertEqual(longitude, -122.0300, accuracy: 0.001)
      geocoderAnswered.fulfill()
    }
    
    waitForExpectations(timeout: 3, handler: nil)
    
  }
  
  func testSave_DismissesViewController() {
    
    let mockInputViewController = MockInputViewController()
    mockInputViewController.titleTextField = UITextField()
    mockInputViewController.dateTextField = UITextField()
    mockInputViewController.locationTextField = UITextField()
    mockInputViewController.addressTextField = UITextField()
    mockInputViewController.descriptionTextField = UITextField()
    mockInputViewController.titleTextField.text = "Test Title"
    
    mockInputViewController.save()
    
    XCTAssertTrue(mockInputViewController.dismissGotCalled)
    
  }
  
}

extension InputViewControllerTests {
  
  class MockGeocoder: CLGeocoder {
    var completionHandler: CLGeocodeCompletionHandler?
    override func geocodeAddressString(_ addressString: String,
                                       completionHandler: @escaping CLGeocodeCompletionHandler) {
      self.completionHandler = completionHandler
    }
  }
  
  class MockPlacemark: CLPlacemark {
    var mockCoordinate: CLLocationCoordinate2D?
    
    override var location: CLLocation? {
      guard let coordinate = mockCoordinate else { return CLLocation() }
      
      return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
  }
  
  class MockInputViewController: InputViewController {
    var dismissGotCalled = false
    var completionHandler: (() -> Void)?
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
      dismissGotCalled = true
      completionHandler?()
    }
  }
  
}
