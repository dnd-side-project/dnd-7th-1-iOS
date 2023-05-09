//
//  FriendAnnotation.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/15.
//

import UIKit
import MapKit

class FriendAnnotation: NSObject, MKAnnotation {
    
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    var title: String?
    
    var color: UIColor?
    
    var profileImage: UIImage?
    
    var challengeCnt: Int?
    
    var isHidden: Bool?
    
    var isEnabled: Bool?
    
    var isBorderOn: Bool?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}
