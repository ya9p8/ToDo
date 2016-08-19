//
//  InputViewControllerTests.swift
//  ToDo
//
//  Created by Yemi Ajibola on 8/9/16.
//  Copyright © 2016 Yemi Ajibola. All rights reserved.
//

import XCTest
@testable import ToDo
import CoreLocation

extension InputViewControllerTests {
    class MockGeocoder: CLGeocoder {
        var completionHandler: CLGeocodeCompletionHandler?
        
        override func geocodeAddressString(addressString: String, completionHandler: CLGeocodeCompletionHandler) {
            self.completionHandler = completionHandler
        }
    }
    
    class MockPlacemark: CLPlacemark {
        var mockCoordinate: CLLocationCoordinate2D?
        
        override var location: CLLocation? {
            guard let coordinate = mockCoordinate else { return
                CLLocation() }
            return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }
    
    class MockInputViewController: InputViewController {
        var dismissedGotCalled = false
        var completionHandler: (() -> Void)?
        
        override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?) {
            dismissedGotCalled = true
            completionHandler?()
        }
    }
}


class InputViewControllerTests: XCTestCase {
    
    var sut: InputViewController!
    var placemark: MockPlacemark!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewControllerWithIdentifier("InputViewController") as! InputViewController
        _ = sut.view
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_HasTitleTextField() {
        XCTAssertNotNil(sut.titleTextField)
    }
    
    func test_HasLocationTextField() {
        XCTAssertNotNil(sut.locationTextField)
    }
    
    func test_HasDateTextField() {
        XCTAssertNotNil(sut.dateTextField)
    }
    
    func test_HasDescriptionTextField() {
        XCTAssertNotNil(sut.descriptionTextField)
    }
    
    func test_HaAddressTextField() {
        XCTAssertNotNil(sut.addressTextField)
    }
    
    func test_HasSaveButton() {
        XCTAssertNotNil(sut.saveButton)
    }
    
    func test_HasCancelButton() {
        XCTAssertNotNil(sut.cancelButton)
    }
    
    func testSave_UsesGeocoderToGetCoordinateFromAddress() {
        let mockInputViewController = MockInputViewController()
        
        mockInputViewController.titleTextField = UITextField()
        mockInputViewController.dateTextField = UITextField()
        mockInputViewController.locationTextField = UITextField()
        mockInputViewController.addressTextField = UITextField()
        mockInputViewController.descriptionTextField = UITextField()
        
        mockInputViewController.titleTextField.text = "Test Title"
        mockInputViewController.dateTextField.text = "02/22/2016"
        mockInputViewController.locationTextField.text = "Office"
        mockInputViewController.addressTextField.text = "Infinite Loop 1, Cupertino"
        mockInputViewController.descriptionTextField.text = "Test Description"
        
        let mockGeocoder = MockGeocoder()
        mockInputViewController.geocoder = mockGeocoder
        mockInputViewController.itemManager = ItemManager()
        
        let expectation = expectationWithDescription("bla")
        
        mockInputViewController.completionHandler = {
            expectation.fulfill()
        }
        
        mockInputViewController.save()
        
        placemark = MockPlacemark()
        let coordinate = CLLocationCoordinate2DMake(37.3316851, -122.0300674)
        placemark.mockCoordinate = coordinate
        mockGeocoder.completionHandler?([placemark], nil)
        waitForExpectationsWithTimeout(1, handler: nil)
        
        let item = mockInputViewController.itemManager?.itemAtIndex(0)
        
        let testItem = ToDoItem(title: "Test Title", itemDescription: "Test Description", timestamp: 1456120800.0, location: Location(name: "Office", coordinate: coordinate))
        
        XCTAssertEqual(item, testItem)
    }
    
//    func testSave_IfNoDate() {
//        sut.titleTextField.text = "Test Title"
//        sut.locationTextField.text = "Office"
//        sut.addressTextField.text = "Infinite Loop 1, Cupertino"
//        sut.descriptionTextField.text = "Test Description"
//        
//        let mockGeocoder = MockGeocoder()
//        sut.geocoder = mockGeocoder
//        
//        sut.itemManager = ItemManager()
//        sut.save()
//        
//        placemark = MockPlacemark()
//        let coordinate = CLLocationCoordinate2DMake(37.3316851, -122.0300674)
//        placemark.mockCoordinate = coordinate
//        mockGeocoder.completionHandler?([placemark], nil)
//        
//        let item = sut.itemManager?.itemAtIndex(0)
//        
//        let testItem = ToDoItem(title: "Test Title", itemDescription: "Test Description", timestamp: nil, location: Location(name: "Office", coordinate: coordinate))
//        
//        XCTAssertEqual(item, testItem)
//    }
//    
//    func testSave_IfNoDescriptionOrDate() {
//        sut.titleTextField.text = "Test Title"
//        sut.locationTextField.text = "Office"
//        sut.addressTextField.text = "Infinite Loop 1, Cupertino"
//        
//        let mockGeocoder = MockGeocoder()
//        sut.geocoder = mockGeocoder
//        
//        sut.itemManager = ItemManager()
//        sut.save()
//        
//        placemark = MockPlacemark()
//        let coordinate = CLLocationCoordinate2DMake(37.3316851, -122.0300674)
//        placemark.mockCoordinate = coordinate
//        mockGeocoder.completionHandler?([placemark], nil)
//        
//        let item = sut.itemManager?.itemAtIndex(0)
//        
//        let testItem = ToDoItem(title: "Test Title", itemDescription: nil, timestamp: nil, location: Location(name: "Office", coordinate: coordinate))
//        
//        XCTAssertEqual(item, testItem)
//    }
//    
//    func testSave_IfNoDescriptionOrDateOrAddress() {
//        sut.titleTextField.text = "Test Title"
//        sut.locationTextField.text = "Office"
//        
//        let mockGeocoder = MockGeocoder()
//        sut.geocoder = mockGeocoder
//        
//        sut.itemManager = ItemManager()
//        sut.save()
//        
//        placemark = MockPlacemark()
//        let coordinate = CLLocationCoordinate2DMake(37.3316851, -122.0300674)
//        placemark.mockCoordinate = coordinate
//        mockGeocoder.completionHandler?([placemark], nil)
//        
//        let item = sut.itemManager?.itemAtIndex(0)
//        
//        let testItem = ToDoItem(title: "Test Title", itemDescription: nil, timestamp: nil, location: Location(name: "Office", coordinate: nil))
//        
//        XCTAssertEqual(item, testItem)
//    }
//    
//    func testSave_IfNoDescriptionOrDateOrAddressOrLocation() {
//        sut.titleTextField.text = "Test Title"
//        
//        let mockGeocoder = MockGeocoder()
//        sut.geocoder = mockGeocoder
//        
//        sut.itemManager = ItemManager()
//        sut.save()
//        
//        placemark = MockPlacemark()
//        let coordinate = CLLocationCoordinate2DMake(37.3316851, -122.0300674)
//        placemark.mockCoordinate = coordinate
//        mockGeocoder.completionHandler?([placemark], nil)
//        
//        let item = sut.itemManager?.itemAtIndex(0)
//        
//        let testItem = ToDoItem(title: "Test Title", itemDescription: nil, timestamp: nil, location: nil)
//        
//        XCTAssertEqual(item, testItem)
//    }
    
    func test_SaveButtonHasSaveAction() {
        let saveButton: UIButton = sut.saveButton
        
        guard let actions = saveButton.actionsForTarget(sut, forControlEvent: .TouchUpInside) else {
            XCTFail(); return
        }
        
        XCTAssertTrue(actions.contains("save"))
    }
    
    func test_GeocoderWorksAsExpected() {
        let expectation = expectationWithDescription("Wait for geocode")
        
        CLGeocoder().geocodeAddressString("Infinite Loop 1, Cupertino") {
            (placemarks, error) in
            let placemark = placemarks?.first
            
            let coordinate = placemark?.location?.coordinate
            guard let latitude = coordinate?.latitude else {
                XCTFail()
                return
            }
            
            guard let longitude = coordinate?.longitude else {
                XCTFail()
                return
            }
            XCTAssertEqualWithAccuracy(latitude, 37.3316851, accuracy: 0.0001)
            XCTAssertEqualWithAccuracy(longitude, -122.0300674, accuracy: 0.0001)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(3, handler: nil)
    }
    
    func testSave_DismissesViewController() {
        let mockInputViewController = MockInputViewController()
        
        mockInputViewController.titleTextField = UITextField()
        mockInputViewController.dateTextField = UITextField()
        mockInputViewController.locationTextField = UITextField()
        mockInputViewController.descriptionTextField = UITextField()
        mockInputViewController.addressTextField = UITextField()
        
        mockInputViewController.titleTextField.text = "Test Title"
        mockInputViewController.save()
        
        XCTAssertTrue(mockInputViewController.dismissedGotCalled)
    }
}
