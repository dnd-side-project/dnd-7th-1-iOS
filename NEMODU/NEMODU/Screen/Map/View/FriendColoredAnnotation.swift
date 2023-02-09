//
//  FriendColoredAnnotation.swift
//  NEMODU
//
//  Created by Kim HeeJae on 2023/01/25.
//

import UIKit
import MapKit

class FriendColoredAnnotation: NSObject, MKAnnotation {
    
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    var title: String?
    
    var color: UIColor?
    
    var profileImage: UIImage?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        
        super.init()
    }
    
}
