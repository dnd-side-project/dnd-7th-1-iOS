//
//  Block.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/18.
//

import MapKit

class Block: MKPolygon {
    var color: UIColor?
    
    convenience init(coordinate: UnsafePointer<CLLocationCoordinate2D>, count: Int, color: UIColor) {
        self.init(coordinates: coordinate, count: count)
        self.color = color
    }
}
