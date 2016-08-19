//
//  Location.swift
//  ToDo
//
//  Created by Yemi Ajibola on 8/2/16.
//  Copyright © 2016 Yemi Ajibola. All rights reserved.
//

import Foundation
import CoreLocation

struct Location : Equatable {
    let name: String
    let coordinate: CLLocationCoordinate2D?
    
    private let nameKey = "nameKey"
    private let latitudeKey = "latitudeKey"
    private let longitudeKey = "longitudeKey"
    
    var plistDict: NSDictionary {
        var dict = [String:AnyObject]()
        
        dict[nameKey] = name
        
        if let coordinate = coordinate {
            dict[latitudeKey] = coordinate.latitude
            dict[longitudeKey] = coordinate.longitude
        }
        
        return dict
    }
    
    init(name: String, coordinate: CLLocationCoordinate2D? = nil) {
        self.name  = name
        self.coordinate = coordinate
    }
    
    init?(dict: NSDictionary) {
        guard let name = dict[nameKey] as? String else { return nil }
        let coordinate: CLLocationCoordinate2D?
        if let latitude = dict[latitudeKey] as? Double, longitude = dict[longitudeKey] as? Double {
            coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        } else {
            coordinate = nil
        }
        
        self.name = name
        self.coordinate = coordinate
    }

}

func ==(lhs: Location, rhs: Location) -> Bool {
    if (rhs.coordinate?.latitude != lhs.coordinate?.latitude) {
        return false
    }
    
    if (rhs.coordinate?.longitude  != lhs.coordinate?.longitude) {
        return false
    }
    
    if(rhs.name != lhs.name) {
        return false
    }
    
    return true
}