//
//  MyAnnotation.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/15.
//

import UIKit
import MapKit

class MyAnnotation: NSObject, MKAnnotation {
    
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    var title: String?
    
    var profileImage: UIImage?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}
