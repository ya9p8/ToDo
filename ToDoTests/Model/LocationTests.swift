//
//  LocationTests.swift
//  ToDo
//
//  Created by Yemi Ajibola on 8/2/16.
//  Copyright © 2016 Yemi Ajibola. All rights reserved.
//

import XCTest
import CoreLocation
@testable import ToDo

class LocationTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func performNotEqualTestWithLocationProperties(firstName: String,
        secondName: String,
        firstLongLat: (Double, Double)?,
        secondLongLat: (Double, Double)?,
        line: UInt = #line) {
        let firstCoord: CLLocationCoordinate2D?
        if let firstLongLat = firstLongLat {
            firstCoord  = CLLocationCoordinate2D(latitude: firstLongLat.0, longitude: firstLongLat.1)
        } else {
            firstCoord = nil
        }
        
        let firstLocation = Location(name: firstName, coordinate: firstCoord)
        
        let secondCoord: CLLocationCoordinate2D?
        if let secondLongLat = secondLongLat {
            secondCoord  = CLLocationCoordinate2D(latitude: secondLongLat.0, longitude: secondLongLat.1)
        } else {
            secondCoord = nil
        }
        
        let secondLocation = Location(name: secondName, coordinate: secondCoord)
        
        XCTAssertNotEqual(firstLocation, secondLocation)
    }
    
    func testInit_ShouldSetNameAndCoordinate() {
        let testCoordinate = CLLocationCoordinate2D(latitude: 1, longitude: 2)
        let location = Location(name: "", coordinate: testCoordinate)
        
        XCTAssertEqual(location.coordinate?.latitude, testCoordinate.latitude, "Initializer should set latitude")
        XCTAssertEqual(location.coordinate?.longitude, testCoordinate.longitude, "Initializer should set longitude")
    }
    
    func testInit_ShouldSetName() {
        let location = Location(name: "Test name")
        
        XCTAssertEqual(location.name, "Test name")
    }
    
    func testEqualLocations_ShouldBeEqual() {
        let firstLocation = Location(name: "Home")
        let secondLocation = Location(name: "Home")
        
        XCTAssertEqual(firstLocation, secondLocation)
    }
    
    func testWhenLatitudeDiffers_ShouldNotBeEqual() {
        performNotEqualTestWithLocationProperties("Home", secondName: "Home", firstLongLat: (1.0, 0.0), secondLongLat: (0.0, 0.0))
    }
    
    func testWhenLongitudeDiffers_ShouldNotBeEqual() {
        let firstCoordinate = CLLocationCoordinate2D(latitude: 1.0, longitude: 0.0)
        let firstLocation = Location(name: "First Location", coordinate: firstCoordinate)
        
        let secondCoordinate = CLLocationCoordinate2D(latitude: 1.0, longitude: 1.0)
        let secondLocation = Location(name: "Second Location", coordinate: secondCoordinate)
        
        XCTAssertNotEqual(firstLocation, secondLocation)
    }
    
    func testWhenOneHasCoordinateAndTheOtherDoesnt_ShouldNotBeEqual() {
        performNotEqualTestWithLocationProperties("Home", secondName: "Home", firstLongLat: (0.0, 0.0), secondLongLat: nil)
    }
    
    func testWhenNameDiffers_ShouldNotBeEqual() {
        performNotEqualTestWithLocationProperties("Home", secondName: "Office", firstLongLat: nil, secondLongLat: nil)
    }
    
    func test_CanBeSerializedAndDeserialized() {
        let location = Location(name: "Home", coordinate: CLLocationCoordinate2DMake(50.0, 60.0))
        let dict = location.plistDict
        
        XCTAssertNotNil(dict)
        
        let recreatedLocation = Location(dict: dict)
        
        XCTAssertEqual(location, recreatedLocation)
    }
    
    
}
